/// 転換導線ナッジ（FEAT-03）の表示判定。純関数。
///
/// - 初回起動から7日経過後の最初の起動で1回目を表示
/// - 1回目から14日後（初回起動から約21日）に2回目を表示
/// - 表示は最大2回。購入済みユーザーには表示しない
/// - コア機能は一切ブロックしない（カード表示のみ、判定はここだけ）
const int kNudgeFirstDelayDays = 7;
const int kNudgeSecondDelayDays = 21; // 7日 + 再表示間隔14日
const int kNudgeMaxShownCount = 2;

bool shouldShowNudge({
  required DateTime? firstLaunchAt,
  required int nudgeShownCount,
  required bool isUnlocked,
  required DateTime now,
}) {
  if (isUnlocked) return false;
  if (firstLaunchAt == null) return false;
  if (nudgeShownCount >= kNudgeMaxShownCount) return false;

  final elapsed = now.difference(firstLaunchAt);
  if (nudgeShownCount == 0) {
    return elapsed >= const Duration(days: kNudgeFirstDelayDays);
  }
  // nudgeShownCount == 1
  return elapsed >= const Duration(days: kNudgeSecondDelayDays);
}
