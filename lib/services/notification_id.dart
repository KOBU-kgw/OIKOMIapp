/// タスクの通知IDを決定的に算出する。
///
/// FNV-1a 32bitで taskId をハッシュし、上位28bitをタスク識別、
/// 下位3bitを stateIndex（0〜5）に割り当てる。32bit signedの正領域
/// （0〜2147483647）に収めるため最上位ビットは落とす。
int notificationId(String taskId, int stateIndex) {
  var hash = 0x811C9DC5;
  for (final unit in taskId.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  final taskBits = hash & 0x0FFFFFFF;
  return (taskBits << 3) | (stateIndex & 0x7);
}
