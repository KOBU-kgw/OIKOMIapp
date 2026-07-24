import 'package:isar/isar.dart';
import 'tgl_state.dart';

part 'user_preference.g.dart';

/// v1.5: サブスク時代のフィールド（有効期限・定期チェック関連）は
/// 買い切り1 SKU 化に伴い削除した。isar はスキーマ変更時、既存行の新規スカラー
/// フィールドを NaN / int.MIN で埋めることがあるため、スカラーは nullable で
/// 保存し安全なアクセサ経由で読む。
@collection
class UserPreference {
  Id id = 0; // シングルトン（常に id=0）

  // ─── 購入状態（買い切りのため有効期限・猶予関連は持たない） ───
  bool isThresholdsUnlocked = false;
  String? lastPurchaseId; // 重複防止用トランザクションID

  // ─── カスタム閾値（値は常に保持。適用は unlocked && useCustomThresholds 時のみ） ───
  double? customPeaceful;
  double? customSomeday;
  double? customReality;
  double? customNoEscape;
  bool useCustomThresholds = false;

  // ─── 転換導線用（FEAT-03） ───
  DateTime? firstLaunchAt;
  int? nudgeShownCountRaw;

  @ignore
  int get nudgeShownCount => nudgeShownCountRaw ?? 0;

  @ignore
  double get peaceful => _sane(customPeaceful) ?? TGLThresholds.peaceful;
  @ignore
  double get someday => _sane(customSomeday) ?? TGLThresholds.someday;
  @ignore
  double get reality => _sane(customReality) ?? TGLThresholds.reality;
  @ignore
  double get noEscape => _sane(customNoEscape) ?? TGLThresholds.noEscape;

  static double? _sane(double? v) => (v == null || v.isNaN) ? null : v;
}
