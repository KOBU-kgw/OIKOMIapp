import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants/sku.dart';

/// 購入フローの純粋判定ロジック（副作用ゼロ・テスト用に分離）。
///
/// [PurchaseService] はこれらを呼ぶ薄いラッパにすることで、
/// 冪等性・productIDゲート・ステータス振り分けの判定を出荷コードのまま
/// ユニットテストできる。Isar / InAppPurchase / 通知には一切依存しない。

/// 購入ストリームの1件をどう扱うかの分類。
enum PurchaseEffect {
  /// 保留中（ボタン無効化）
  pending,

  /// エラー（メッセージ表示）
  error,

  /// ユーザーキャンセル（エラー表示しない）
  canceled,

  /// 解放処理を実行すべき（購入/復元 かつ 対象SKU）
  fulfill,

  /// 対象外SKUなど、解放処理は不要
  ignore,
}

/// 購入ステータス＋productID から実行すべき副作用を分類する。
/// purchased / restored でも対象SKU以外は [PurchaseEffect.ignore]。
PurchaseEffect classifyPurchaseStatus(
  PurchaseStatus status, {
  required String productId,
}) {
  switch (status) {
    case PurchaseStatus.pending:
      return PurchaseEffect.pending;
    case PurchaseStatus.error:
      return PurchaseEffect.error;
    case PurchaseStatus.canceled:
      return PurchaseEffect.canceled;
    case PurchaseStatus.purchased:
    case PurchaseStatus.restored:
      return productId == AppSku.unlockThresholds
          ? PurchaseEffect.fulfill
          : PurchaseEffect.ignore;
  }
}

/// 解放処理の結果（適用後の [UserPreference] 相当の値と、永続化要否）。
class UnlockOutcome {
  const UnlockOutcome({
    required this.shouldPersist,
    required this.isThresholdsUnlocked,
    required this.lastPurchaseId,
  });

  /// 保存 + ThresholdProvider.reload + 通知再同期 を実行すべきか。
  /// false は同一トランザクションの再配送（冪等 no-op）を意味する。
  final bool shouldPersist;

  /// 適用後の UserPreference.isThresholdsUnlocked
  final bool isThresholdsUnlocked;

  /// 適用後の UserPreference.lastPurchaseId
  final String? lastPurchaseId;
}

/// 解放判定（冪等）。
///
/// 既に解放済みで、届いた purchaseID が記録済みの直近IDと一致する場合のみ
/// 再配送とみなして [UnlockOutcome.shouldPersist] を false にする。
/// それ以外は解放を適用し、lastPurchaseId は届いたIDで更新
/// （null のときは現状維持）。
UnlockOutcome resolveUnlock({
  required bool currentlyUnlocked,
  required String? currentLastPurchaseId,
  required String? incomingPurchaseId,
}) {
  final isDuplicate = currentlyUnlocked &&
      incomingPurchaseId != null &&
      currentLastPurchaseId == incomingPurchaseId;
  if (isDuplicate) {
    return UnlockOutcome(
      shouldPersist: false,
      isThresholdsUnlocked: true,
      lastPurchaseId: currentLastPurchaseId,
    );
  }
  return UnlockOutcome(
    shouldPersist: true,
    isThresholdsUnlocked: true,
    lastPurchaseId: incomingPurchaseId ?? currentLastPurchaseId,
  );
}
