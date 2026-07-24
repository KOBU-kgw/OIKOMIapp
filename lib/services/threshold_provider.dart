import 'package:flutter/foundation.dart';
import '../models/tgl_state.dart';
import '../models/user_preference.dart';
import 'database_service.dart';

/// 現在有効なTGL閾値セットの供給元（v1.5 カスタム閾値パック）。
///
/// - 起動時に [reload] で読み込み、閾値保存・購入・復元のたびに再読込する
/// - 解放済み（isThresholdsUnlocked）かつ有効化（useCustomThresholds）の
///   ときのみカスタム値、それ以外はデフォルト
/// - TGL計算式そのものには一切作用しない（ラベル変換と通知逆算にのみ使う）
class ThresholdProvider {
  ThresholdProvider._();

  static TGLThresholdSet _current = TGLThresholdSet.defaults;

  static TGLThresholdSet get current => _current;

  static Future<void> reload() async {
    _current = fromPreference(await DatabaseService.getUserPreference());
  }

  /// UserPreference → 有効な閾値セットへの変換（純関数・テスト用に公開）。
  /// 解放済み かつ 有効化 のときのみカスタム値を適用する。
  static TGLThresholdSet fromPreference(UserPreference pref) {
    return pref.isThresholdsUnlocked && pref.useCustomThresholds
        ? TGLThresholdSet(
            peaceful: pref.peaceful,
            someday: pref.someday,
            reality: pref.reality,
            noEscape: pref.noEscape,
          )
        : TGLThresholdSet.defaults;
  }

  @visibleForTesting
  static void override(TGLThresholdSet set) => _current = set;

  @visibleForTesting
  static void resetToDefaults() => _current = TGLThresholdSet.defaults;
}
