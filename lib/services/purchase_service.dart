import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants/sku.dart';
import 'database_service.dart';
import 'notification_service.dart';
import 'purchase_logic.dart';
import 'threshold_provider.dart';

/// カスタム閾値パック（買い切り非消耗型IAP）の購入管理。
///
/// - 失効処理・期限チェック・グレースピリオドは存在しない（買い切りのため）
/// - 検証はローカルのみ（サーバーレス原則）
/// - ストア接続不能・商品未登録でもアプリ本体は完全動作すること
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._();
  factory PurchaseService() => _instance;
  PurchaseService._();

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// ストアが利用可能か（実機・ストアアカウントあり）
  final ValueNotifier<bool> storeAvailable = ValueNotifier(false);

  /// カスタム閾値パックの商品情報（取得失敗時は null）
  final ValueNotifier<ProductDetails?> product = ValueNotifier(null);

  /// 商品情報を取得中か（ローディング表示用）
  final ValueNotifier<bool> productLoading = ValueNotifier(false);

  /// 購入処理中か（ボタン無効化用）
  final ValueNotifier<bool> purchasePending = ValueNotifier(false);

  /// 解放済みか（UserPreference.isThresholdsUnlocked のミラー）
  final ValueNotifier<bool> isUnlocked = ValueNotifier(false);

  /// 直近のエラーメッセージ（ユーザーキャンセルは含めない）
  final ValueNotifier<String?> lastError = ValueNotifier(null);

  Future<void> initialize() async {
    // 先に購読を開始する（起動時に配送される保留トランザクションを取りこぼさない）
    _subscription ??= InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (Object e) => debugPrint('purchaseStream error: $e'),
    );

    final pref = await DatabaseService.getUserPreference();
    isUnlocked.value = pref.isThresholdsUnlocked;

    await refreshProduct();
  }

  /// 商品情報を（再）取得する。購入画面のリトライボタン・画面表示時から呼べる。
  /// ストア接続不能・商品未登録でもアプリ本体は通常動作を続ける。
  Future<void> refreshProduct() async {
    productLoading.value = true;
    lastError.value = null;
    try {
      storeAvailable.value = await InAppPurchase.instance.isAvailable();
      if (!storeAvailable.value) {
        product.value = null;
        return;
      }

      final response =
          await InAppPurchase.instance.queryProductDetails(AppSku.allSkus);
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('IAP products not found: ${response.notFoundIDs}');
      }
      product.value = response.productDetails
          .where((p) => p.id == AppSku.unlockThresholds)
          .firstOrNull;
    } catch (e) {
      debugPrint('refreshProduct failed: $e');
      storeAvailable.value = false;
      product.value = null;
    } finally {
      productLoading.value = false;
    }
  }

  Future<void> buy() async {
    final details = product.value;
    if (details == null) return;
    lastError.value = null;
    try {
      purchasePending.value = true;
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: details),
      );
    } on PlatformException catch (e) {
      // 進行中トランザクションがある場合など
      purchasePending.value = false;
      lastError.value = e.message;
      debugPrint('buy failed: $e');
    } catch (e) {
      purchasePending.value = false;
      lastError.value = e.toString();
      debugPrint('buy failed: $e');
    }
  }

  Future<void> restore() async {
    lastError.value = null;
    try {
      purchasePending.value = true;
      // 結果は purchaseStream に PurchaseStatus.restored として届く
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      lastError.value = e.toString();
      debugPrint('restore failed: $e');
    } finally {
      purchasePending.value = false;
    }
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> detailsList) async {
    for (final details in detailsList) {
      final effect = classifyPurchaseStatus(details.status,
          productId: details.productID);
      switch (effect) {
        case PurchaseEffect.pending:
          purchasePending.value = true;
        case PurchaseEffect.error:
          purchasePending.value = false;
          lastError.value = details.error?.message;
          debugPrint('purchase error: ${details.error}');
        case PurchaseEffect.canceled:
          purchasePending.value = false; // キャンセルはエラー表示しない
        case PurchaseEffect.ignore:
          purchasePending.value = false; // 対象外SKU: 解放しない
        case PurchaseEffect.fulfill:
          purchasePending.value = false;
          await _unlock(details);
      }
      // どのステータスでも必ず完了させる（iOSのトランザクション再配送ループ防止）
      if (details.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(details);
        } catch (e) {
          debugPrint('completePurchase failed: $e');
        }
      }
    }
  }

  Future<void> _unlock(PurchaseDetails details) async {
    final pref = await DatabaseService.getUserPreference();
    final outcome = resolveUnlock(
      currentlyUnlocked: pref.isThresholdsUnlocked,
      currentLastPurchaseId: pref.lastPurchaseId,
      incomingPurchaseId: details.purchaseID,
    );
    // 同一トランザクションの再配送は無視（冪等）
    if (!outcome.shouldPersist) {
      isUnlocked.value = true;
      return;
    }
    pref.isThresholdsUnlocked = outcome.isThresholdsUnlocked;
    pref.lastPurchaseId = outcome.lastPurchaseId;
    await DatabaseService.saveUserPreference(pref);
    await ThresholdProvider.reload();
    NotificationService.requestResync();
    isUnlocked.value = true;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
