enum TGLState {
  peaceful,
  someday,
  reality,
  noEscape,
  war,
  overdue,
}

class TGLThresholds {
  static const double peaceful = 0.4;
  static const double someday  = 1.5;
  static const double reality  = 6.0;
  static const double noEscape = 20.0;
}

/// 状態ラベル変換・通知逆算に使う閾値セット（v1.5: カスタム閾値パック対応）。
/// peaceful < someday < reality < noEscape の狭義単調増加を前提とする。
class TGLThresholdSet {
  const TGLThresholdSet({
    required this.peaceful,
    required this.someday,
    required this.reality,
    required this.noEscape,
  });

  final double peaceful;
  final double someday;
  final double reality;
  final double noEscape;

  static const TGLThresholdSet defaults = TGLThresholdSet(
    peaceful: TGLThresholds.peaceful,
    someday: TGLThresholds.someday,
    reality: TGLThresholds.reality,
    noEscape: TGLThresholds.noEscape,
  );
}
