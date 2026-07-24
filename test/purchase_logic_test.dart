import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:my_app/constants/sku.dart';
import 'package:my_app/services/purchase_logic.dart';

void main() {
  group('resolveUnlock (冪等な解放判定)', () {
    test('新規購入: 未解放 → 解放を永続化', () {
      final o = resolveUnlock(
        currentlyUnlocked: false,
        currentLastPurchaseId: null,
        incomingPurchaseId: 'tx1',
      );
      expect(o.shouldPersist, isTrue);
      expect(o.isThresholdsUnlocked, isTrue);
      expect(o.lastPurchaseId, 'tx1');
    });

    test('再配送: 解放済み かつ 同一ID → 冪等 no-op', () {
      final o = resolveUnlock(
        currentlyUnlocked: true,
        currentLastPurchaseId: 'tx1',
        incomingPurchaseId: 'tx1',
      );
      expect(o.shouldPersist, isFalse);
      expect(o.isThresholdsUnlocked, isTrue);
    });

    test('別トランザクション: 解放済み だが 異なるID（復元）→ 更新して永続化', () {
      final o = resolveUnlock(
        currentlyUnlocked: true,
        currentLastPurchaseId: 'tx1',
        incomingPurchaseId: 'tx2',
      );
      expect(o.shouldPersist, isTrue);
      expect(o.lastPurchaseId, 'tx2');
    });

    test('incoming purchaseID=null: 未解放 → 解放しlastIdは現状維持(null)', () {
      final o = resolveUnlock(
        currentlyUnlocked: false,
        currentLastPurchaseId: null,
        incomingPurchaseId: null,
      );
      expect(o.shouldPersist, isTrue);
      expect(o.isThresholdsUnlocked, isTrue);
      expect(o.lastPurchaseId, isNull);
    });

    test('incoming null かつ 解放済み: guard外れ永続化・既存lastIdを保持', () {
      // purchaseID==null は再配送ガードを満たさないため永続化側に倒れる。
      // lastPurchaseId は既存値を維持する（現行挙動の明文化）。
      final o = resolveUnlock(
        currentlyUnlocked: true,
        currentLastPurchaseId: 'tx1',
        incomingPurchaseId: null,
      );
      expect(o.shouldPersist, isTrue);
      expect(o.lastPurchaseId, 'tx1');
    });
  });

  group('classifyPurchaseStatus (ステータス振り分け)', () {
    test('purchased + 対象SKU → fulfill', () {
      expect(
        classifyPurchaseStatus(PurchaseStatus.purchased,
            productId: AppSku.unlockThresholds),
        PurchaseEffect.fulfill,
      );
    });

    test('purchased + 対象外SKU → ignore', () {
      expect(
        classifyPurchaseStatus(PurchaseStatus.purchased,
            productId: 'some.other.sku'),
        PurchaseEffect.ignore,
      );
    });

    test('restored + 対象SKU → fulfill', () {
      expect(
        classifyPurchaseStatus(PurchaseStatus.restored,
            productId: AppSku.unlockThresholds),
        PurchaseEffect.fulfill,
      );
    });

    test('pending / error / canceled はそのまま対応', () {
      expect(
        classifyPurchaseStatus(PurchaseStatus.pending,
            productId: AppSku.unlockThresholds),
        PurchaseEffect.pending,
      );
      expect(
        classifyPurchaseStatus(PurchaseStatus.error,
            productId: AppSku.unlockThresholds),
        PurchaseEffect.error,
      );
      expect(
        classifyPurchaseStatus(PurchaseStatus.canceled,
            productId: AppSku.unlockThresholds),
        PurchaseEffect.canceled,
      );
    });
  });
}
