import 'dart:math' show max, min;

/// 閾値スライダーの可動範囲（仕様の確定値）
class ThresholdRange {
  const ThresholdRange(this.min, this.max);
  final double min;
  final double max;
}

/// index: 0=peaceful, 1=someday, 2=reality, 3=noEscape
const List<ThresholdRange> kThresholdRanges = [
  ThresholdRange(0.1, 2.0),
  ThresholdRange(0.5, 5.0),
  ThresholdRange(2.0, 15.0),
  ThresholdRange(5.0, 50.0),
];

/// 隣接閾値との最小ギャップ（狭義単調増加 peaceful < someday < reality < noEscape を保証）
const double kThresholdGap = 0.1;

/// スライダー操作値を「可動範囲＋隣接値±ギャップ」でクランプする。
/// [current] は現在の4値（index順）。onChanged内で呼び、隣接値を越えられなくする。
double clampThreshold(int index, double value, List<double> current) {
  assert(index >= 0 && index < 4 && current.length == 4);
  var lo = kThresholdRanges[index].min;
  var hi = kThresholdRanges[index].max;
  if (index > 0) lo = max(lo, current[index - 1] + kThresholdGap);
  if (index < 3) hi = min(hi, current[index + 1] - kThresholdGap);
  if (lo > hi) return current[index]; // 挟み撃ちで可動域が消えた場合は動かさない
  return value.clamp(lo, hi);
}
