/// アプリ内課金のSKU定義（v1.5: 買い切り1 SKUのみ）。
/// SKU IDは作成後変更不可の確定値。両ストアで同一IDで登録する。
class AppSku {
  static const String unlockThresholds = 'oikomi.unlock.thresholds';

  static const Set<String> allSkus = {unlockThresholds};
}
