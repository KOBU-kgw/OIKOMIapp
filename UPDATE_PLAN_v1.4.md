# OIKOMI v1.4 — Claude Code 実装プロンプト

## メタ情報

| 項目 | 内容 |
|---|---|
| アプリ名 | OIKOMI |
| バージョン | v1.3 → v1.4 |
| リリース目標 | 2026年6月中旬 |
| 方針 | バグ修正 + 軽微なUX改善（スコープは小さく、確実に） |
| パッケージ名 | `com.kobu.oikomi` |

---

## 前提知識（必ず読むこと）

このアプリは **TGL（Task Gotta Level）** という独自指標で課題の「精神的ヤバさ」を管理するタスク管理アプリ。

計算式：`TGL = (T × M) / max(effectiveD - T, ε)`

- `T` = 所要時間（時間）
- `M` = やりたくなさ（1〜10）
- `effectiveD` = 実効稼働時間（後述）
- `ε = 0.01`（ゼロ除算防止）

TGL数値は**ユーザーに絶対表示しない**。状態ラベルのみ表示する。

---

## このバージョンの変更内容

### [FIX-01] 通知タイミング補正 — 睡眠時間を除外した実効稼働時間ベースに変更

#### 問題

現在のTGL計算・通知スケジューリングは「カレンダー時間（24時間換算）」でslackを計算している。  
そのため睡眠中の時間も「使える時間」としてカウントされ、実態より通知タイミングが遅くなっている。

#### 修正方針

1日の稼働時間を **18時間（睡眠6時間想定）** としてハードコードし、  
カレンダー時間を実効稼働時間に換算してからTGLを計算する。

#### 定数定義

**`lib/services/tgl_calculator.dart` の先頭に追加：**

```dart
/// 1日の想定稼働時間（大学生想定: 睡眠6時間除く18時間）
const double kActiveHoursPerDay = 18.0;

/// カレンダー時間 → 実効稼働時間の換算係数
const double kActiveRatio = kActiveHoursPerDay / 24.0; // 0.75
```

#### `calculateTGL` の変更

**変更前：**
```dart
double calculateTGL(Task task) {
  final now = DateTime.now();
  final D = task.deadline.difference(now).inMinutes / 60.0;
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final slack = max(D - T, epsilon);
  final tgl = (T * M) / slack;
  return tgl;
}
```

**変更後：**
```dart
double calculateTGL(Task task) {
  final now = DateTime.now();
  final calendarHours = task.deadline.difference(now).inMinutes / 60.0;
  final effectiveHours = calendarHours * kActiveRatio; // 実効稼働時間に換算
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final slack = max(effectiveHours - T, epsilon);
  final tgl = (T * M) / slack;
  return tgl;
}
```

> **シグネチャは変更しない。** `calculateTGL(Task task)` のまま。

#### `_calculateTransitionTime` の変更

**ファイル：** `lib/services/notification_service.dart`

通知遷移タイミングの逆算式を実効稼働時間ベースに修正する。

**変更前：**
```dart
DateTime? _calculateTransitionTime(Task task, TGLState state) {
  final threshold = _thresholdFor(state);
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final requiredSlack = (T * M) / threshold;
  final requiredD = T + requiredSlack;
  final triggerTime = task.deadline.subtract(
    Duration(milliseconds: (requiredD * 3600 * 1000).toInt()),
  );
  return triggerTime;
}
```

**変更後：**
```dart
DateTime? _calculateTransitionTime(Task task, TGLState state) {
  final threshold = _thresholdFor(state);
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final requiredSlack = (T * M) / threshold;
  final requiredEffectiveD = T + requiredSlack;
  // 実効稼働時間 → カレンダー時間に逆算してdeadlineから引く
  final requiredCalendarD = requiredEffectiveD / kActiveRatio;
  final triggerTime = task.deadline.subtract(
    Duration(milliseconds: (requiredCalendarD * 3600 * 1000).toInt()),
  );
  return triggerTime;
}
```

> **重要：** `kActiveRatio` は `tgl_calculator.dart` で定義した定数を import して使うこと。  
> `notification_service.dart` に同じ定数を再定義しない。

---

### [FEAT-01] ソート切り替えトグル（TGL高い順 ↔ 締切日時順）

#### 概要

タスク一覧のナビゲーションバーにアイコンボタンを追加し、  
ソート順を **TGL高い順（デフォルト）** と **締切日時が近い順** で切り替えられるようにする。

#### 新規 enum 追加

**`lib/models/task_sort_order.dart` を新規作成：**

```dart
enum TaskSortOrder {
  tgl,      // TGL降順（ヤバい順）← デフォルト
  deadline, // 締切昇順（締切が近い順）
}
```

#### タスク一覧画面の変更

**ファイル：** `lib/screens/task_list_screen.dart`（または相当するファイル）

**State変数を追加：**
```dart
TaskSortOrder _sortOrder = TaskSortOrder.tgl;
```

**ナビゲーションバーの `actions` にトグルボタンを追加：**
```dart
IconButton(
  icon: Icon(
    _sortOrder == TaskSortOrder.tgl
        ? Icons.warning_amber_rounded  // TGL順を示すアイコン
        : Icons.access_time_rounded,   // 締切順を示すアイコン
  ),
  tooltip: _sortOrder == TaskSortOrder.tgl
      ? '締切が近い順に切り替え'
      : 'ヤバい順に切り替え',
  onPressed: () {
    setState(() {
      _sortOrder = _sortOrder == TaskSortOrder.tgl
          ? TaskSortOrder.deadline
          : TaskSortOrder.tgl;
    });
  },
)
```

**ソートロジック（既存のソートを置き換え）：**
```dart
List<Task> _sortedTasks(List<Task> tasks) {
  final incomplete = tasks.where((t) => !t.isCompleted).toList();
  switch (_sortOrder) {
    case TaskSortOrder.tgl:
      incomplete.sort((a, b) =>
          calculateTGL(b).compareTo(calculateTGL(a))); // TGL降順
    case TaskSortOrder.deadline:
      incomplete.sort((a, b) =>
          a.deadline.compareTo(b.deadline)); // 締切昇順
  }
  return incomplete;
}
```

#### 補足仕様

- ソート状態はセッション内メモリで保持（DB永続化しない）
- アプリ再起動時はTGL順（デフォルト）に戻る
- ソート切り替え後にタスクを追加・編集した場合、現在のソート順を維持する

---



## スコープ外（このバージョンで絶対に実装しない）

| 機能 | 理由 | 予定バージョン |
|---|---|---|
| マルチタスク補正（先行タスクの所要時間をslackから差し引く） | 通知再計算の複雑化・上限64件問題との干渉リスク | v1.5以降 |
| カスタムTGL閾値 | Premium機能 | v1.5 |
| 設定画面 | スコープ外 | 未定 |
| `calculateTGL` のシグネチャ変更（引数追加など） | 後方互換性維持 | v1.5以降 |

---

## テスト要件

### FIX-01（睡眠補正）の検証シナリオ

| シナリオ | 計算手順 | 期待するTGLState |
|---|---|---|
| 締切72時間後・T=5h・M=8 | effectiveHours=54h、slack=49h、TGL=40/49≈0.82 | `someday`（そのうちやろ） |
| 締切24時間後・T=5h・M=8 | effectiveHours=18h、slack=13h、TGL=40/13≈3.08 | `reality`（そろそろ現実） |
| 締切3時間後・T=2h・M=5 | effectiveHours=2.25h、slack=0.25h、TGL=10/0.25=40 | `war`（戦争） |
| 締切1時間後・T=2h・M=5 | effectiveHours=0.75h、slack=ε、TGL=極大 | `war`（戦争） |
| v1.3と同条件で比較 | 全タスクでTGLが高くなること | ― |

### FEAT-01（ソートトグル）の検証シナリオ

| シナリオ | 期待動作 |
|---|---|
| 初期表示 | TGL降順でソート済み・アイコンは `warning_amber_rounded` |
| アイコンタップ1回目 | 締切昇順に切り替わり・アイコンは `access_time_rounded` |
| アイコンタップ2回目 | TGL降順に戻る・アイコンも戻る |
| ソート切り替え後にタスク追加 | 追加後も現在のソート順を維持 |
| 完了済みタスクが含まれる場合 | ソート対象は未完了タスクのみ（既存仕様と同じ） |

---

## 注意事項（必ず守ること）

1. **TGL数値はユーザーに絶対表示しない。** 状態ラベル（まだ平和〜戦争）のみ。
2. **`kActiveRatio` 定数は `tgl_calculator.dart` で一元管理。** `notification_service.dart` に再定義しない。
3. **`calculateTGL` のシグネチャを変更しない。** `Task` 1つを受け取るまま。
4. **通知上限64件チェックは既存ロジックを維持する。** 変更しない。
5. **TGLThresholds の閾値は変更しない。**（peaceful=0.4 / someday=1.5 / reality=6 / noEscape=20）
6. **マルチタスク補正はスコープ外。** 実装しない・コメントも残さない。

---

## 変更ファイルサマリー

| ファイル | 変更種別 | 変更内容 |
|---|---|---|
| `lib/services/tgl_calculator.dart` | 修正 | `kActiveHoursPerDay`, `kActiveRatio` 定数追加・`calculateTGL` 修正 |
| `lib/services/notification_service.dart` | 修正 | `_calculateTransitionTime` 修正（`kActiveRatio` でカレンダー時間を逆算） |
| `lib/models/task_sort_order.dart` | 新規作成 | `TaskSortOrder` enum 定義 |
| `lib/screens/task_list_screen.dart` | 修正 | ソートトグルボタン追加・`_sortedTasks` メソッド修正 |

---

**Document Version**: 1.0  
**作成日**: 2026年6月  
**ステータス**: 実装待ち
