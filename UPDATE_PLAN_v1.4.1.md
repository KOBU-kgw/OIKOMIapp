# OIKOMI v1.4.1 — Hotfix 実装プロンプト（通知リスケジュール不具合）

## メタ情報

| 項目 | 内容 |
|---|---|
| バージョン | v1.4 → v1.4.1（hotfix） |
| 種別 | バグ修正のみ（新機能なし） |
| 対象 | ユーザー報告：完了前タスクの締切日時・所要時間を変更すると、**変更前の通知が予期しないタイミングで届く** |
| パッケージ名 | `com.kobu.oikomi` |

---

## 重要：報告された「原因の推測」は採用しない

ユーザーからの希望は「日時変更したら通知をリセットしてから再スケジュールしたい」だが、
**そのリセット処理はすでに実装済み**である。コードを直接修正する前に、以下を理解すること。

### 既存実装で「すでに正しく動いているはずの部分」

- `NotificationService.scheduleNotificationsForTask()` は冒頭で必ず
  `cancelNotificationsForTask(task.id)` を呼んでいる（＝リセット済み）
- 通知IDは `_notificationId(task.id, stateIndex)` で導出。`task.id` はUUIDで**編集しても不変**、
  `stateIndex` は 0〜5 で固定 → **編集前後で通知IDは一致**する
- `cancelNotificationsForTask()` は `for i in 0..5` で 0〜5 を全キャンセル。
  予約に使うID（遷移0〜3, hopeless=5）を漏れなくカバーしている
- 編集保存（`task_form_screen.dart`）は `widget.task ?? Task()` を再利用するため
  `isarId` が保持され、DBは同一行を**上書き更新**（重複行は発生しない）

→ したがって「キャンセルを足す」「リセットを足す」という方向の修正は**空振りする**。
   旧通知がキャンセルをすり抜けて発火する、別の経路を塞ぐ必要がある。

### 旧通知がキャンセルをすり抜ける現実的な2経路

| 候補 | 内容 | 種別 |
|---|---|---|
| **A: 通知IDのハッシュ衝突** | `_notificationId` が `hash % 1000000` でエントロピーを捨てており、別タスク同士が同一IDバケットに落ちうる。タスクXのキャンセル/再予約が、衝突するタスクYの予約を上書き・除去し、結果として旧予約が生き残る or 消える。タスク総数が増えるほど顕在化 | コードの実バグ |
| **B: 配信済み通知** | 旧トリガー時刻が編集より前に経過しており、バックグラウンドで通知トレイに配信済みだった。`cancel()` は未配信(pending)を消すが、すでに配信された通知はユーザーに届いた後 | 仕様の見え方 |

---

## 手順0：原因の確定（実装前に必ず実施）

修正方針が候補A/Bで変わるため、**コードを書き換える前に2行のログで切り分ける**こと。

### 計測コード（一時的に挿入）

`scheduleNotificationsForTask()` の末尾、または編集保存直後に挿入：

```dart
final pending = await _plugin.pendingNotificationRequests();
debugPrint('[NOTIF] pending after edit: '
    '${pending.map((p) => "id=${p.id} title=${p.title}").toList()}');
```

### 再現手順と判定

1. タスクを1件作成（数分後に通知が出る締切に設定）
2. 完了せずに締切日時を**後ろ倒し**に変更して保存
3. ログの pending を確認

| 観測 | 確定した原因 | この後の対応 |
|---|---|---|
| pending に旧トリガー相当のIDが残存、または別タスクのIDが消えている | **候補A（衝突）** | FIX-1 ＋ FIX-2 を両方適用 |
| pending は正しく更新されているのに通知が届く | **候補B（配信済み）** | FIX-1 のみで十分（cancelAll が配信済みもクリア） |

> どちらに転んでも FIX-1 は適用する。FIX-2（ID設計）は候補A確定時に必須、B確定時も予防として推奨。

---

## FIX-1：全タスク再スケジュールへの一本化（候補A・B両対応）

### 方針

個別タスクの cancel→schedule をやめ、**あらゆるタスク変更を「全キャンセル → DBから全件再スケジュール」の一本道**に統一する。
これは `main.dart` の `_onAppLaunch()` がすでに行っている `rescheduleAllNotifications()`（`cancelAll()` ＋ 全再登録）と同じ処理を、保存・完了・削除・Undoの直後にも通すだけ。

`cancelAll()` を通すことで:
- 候補A：衝突由来の孤児通知も含めて全消去されるため、旧予約が生き残れない
- 候補B：iOSでは `cancelAll()` が `removeAllDeliveredNotifications` も実行し、トレイの配信済みも消える

### 実装

#### 1. NotificationService に統一エントリポイントを追加

既存の `rescheduleAllNotifications(List<Task> tasks)` を活用し、DB読み込み込みのラッパーを用意する。

```dart
// NotificationService に追加
// DBから未完了タスクを読み直して全再スケジュールする統一エントリポイント
static Future<void> resyncFromDatabase() async {
  final tasks = await DatabaseService.getAllIncompleteTasks();
  await rescheduleAllNotifications(tasks); // 内部で cancelAll() 済み
}
```

> 循環参照に注意：`NotificationService` から `DatabaseService` を参照する形になる。
> もし設計上 service 間の依存を避けたい場合は、呼び出し側（screen）で
> `getAllIncompleteTasks()` → `rescheduleAllNotifications(tasks)` の2行を呼ぶ形でもよい。
> どちらかに統一すること。

#### 2. 全ミューテーション後に resync を呼ぶ

以下の箇所で、**個別の** `scheduleNotificationsForTask` / `cancelNotificationsForTask` 呼び出しを
**全件 resync に置き換える**。

| ファイル | 対象メソッド | 変更 |
|---|---|---|
| `task_form_screen.dart` | `_save()` | `scheduleNotificationsForTask(task)` → `resyncFromDatabase()` |
| `task_detail_screen.dart` | 保存処理（存在する場合） | 同上 |
| `task_detail_screen.dart` | `_complete()` | `cancelNotificationsForTask(taskId)` → `resyncFromDatabase()` |
| `task_detail_screen.dart` | `_complete()` のUndo | `scheduleNotificationsForTask(t)` → `resyncFromDatabase()` |
| `task_detail_screen.dart` | `_delete()` | `cancelNotificationsForTask(taskId)` → `resyncFromDatabase()` |
| `task_detail_screen.dart` | `_delete()` のUndo | `scheduleNotificationsForTask(t)` → `resyncFromDatabase()` |
| 一覧画面のスワイプ操作（完了/削除/編集）があれば | 各ハンドラ | 同上 |

> **順序の厳守**：必ず `DatabaseService` への書き込み（saveTask / markCompleted / softDeleteTask / undo*）を
> `await` で**完了させてから** `resyncFromDatabase()` を呼ぶこと。
> resync はDBの現在状態を正とするため、DB更新前に呼ぶと古い状態で再スケジュールしてしまう。

#### 3. 連打対策（任意だが推奨）

Undoスナックバー操作や連続編集で resync が短時間に複数回走らないよう、軽いデバウンスを入れてもよい。
ただしhotfixのスコープでは**必須ではない**（v1.5でFEAT-01と合わせて 300〜500ms デバウンスを正式導入する想定）。
入れる場合も「最後の操作が必ず反映される」trailing実行にすること。

---

## FIX-2：通知IDの衝突対策（候補A確定時は必須）

### 問題

```dart
static int _notificationId(String taskId, int stateIndex) {
  var hash = 0x811C9DC5;
  for (final unit in taskId.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return (hash % 1000000) * 10 + stateIndex; // ← % 1000000 でエントロピーを捨てている
}
```

`% 1000000` でハッシュ空間を100万バケットに圧縮しているため、別タスクが同一バケットに落ちる確率が
無視できない（タスク数N件で誕生日のパラドックス的に増加）。

### 修正

Androidの通知IDは **32bit signed int**（最大 2,147,483,647）に収まればよい。
`stateIndex` 用に下位ビットを確保しつつ、ハッシュの有効ビットを最大化する。

```dart
static int _notificationId(String taskId, int stateIndex) {
  // FNV-1a 32bit（決定的）
  var hash = 0x811C9DC5;
  for (final unit in taskId.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  // stateIndex は 0..5 → 3bit で表現可能。
  // 上位29bitをタスク識別、下位3bitを stateIndex に割り当てる。
  // 32bit signed の正領域に収めるため最上位ビットを落とす（& 0x0FFFFFFF で28bit確保）。
  final taskBits = hash & 0x0FFFFFFF;        // 28bit（約2.68億バケット、衝突確率を従来の268倍改善）
  return (taskBits << 3) | (stateIndex & 0x7); // 下位3bitに stateIndex
}
```

> **注意**：ID算出式を変えると、**旧式で予約済みの通知が新式のキャンセル対象から外れる**。
> ただし FIX-1 で `cancelAll()` を全面採用するため、アプリ起動時または初回ミューテーション時に
> 旧式の予約も含めて一掃される。**FIX-2 は必ず FIX-1 とセットで入れること**（単独適用は孤児を生む）。

> `cancelNotificationsForTask()` のループ `for i in 0..5` は引き続き有効（stateIndex 0〜5 を網羅）。
> ただし FIX-1 適用後はこのメソッド自体がほぼ使われなくなる（resync が cancelAll を使うため）。
> 残す場合も新式の `_notificationId` を参照していれば整合する。

---

## FIX-3（確認のみ）：hopeless通知の即時発火

`scheduleNotificationsForTask` 内の hopeless 通知は `DateTime.now() + 2秒` で発火する：

```dart
triggerTime: DateTime.now().add(const Duration(seconds: 2)),
```

これは「編集して詰み状態になった瞬間に通知」する**意図的な仕様**。
ただしFIX-1で編集のたびに全 resync が走るため、**hopeless状態のタスクが存在すると、無関係なタスクを
編集しただけでも hopeless 通知が2秒後に再発火**しうる。これがユーザーに「予期しない通知」と
受け取られる可能性がある。

### 対応（要判断）

- **採用案**：hopeless通知は「状態が overdue/hopeless に**変化した初回のみ**」発火させ、
  既にhopeless済みのタスクはresync時に再発火させない。
  → `UserPreference` か Task に `hopelessNotifiedAt` を持たせ、未通知時のみ即時発火する。
- hotfixのスコープを最小にするなら、本FIXは**v1.5送り**にして、v1.4.1では手順0のログで
  「報告された不具合がhopeless再発火かどうか」だけ確認しておく。

> どちらにするかは手順0の結果次第。報告症状がhopeless由来でなければ v1.5送りでよい。

---

## テストシナリオ

| # | シナリオ | 期待 |
|---|---|---|
| 1 | タスクの締切を後ろ倒しに編集 | 旧トリガーの通知が発火しない。新トリガーで1回だけ通知 |
| 2 | タスクの締切を前倒しに編集 | 旧通知は消え、新しい（早い）トリガーで通知 |
| 3 | 所要時間(T)を大幅増で編集 | 状態遷移が早まり、通知タイミングが前倒しになる。旧通知は残らない |
| 4 | タスクAを編集 → タスクB（無関係）の通知が変化しないこと | Bの予約が巻き込まれて消えない（衝突対策の確認） |
| 5 | 多数タスク（20件以上）作成後、1件編集 | pending が正しく、孤児通知ゼロ。予約総数が上限内 |
| 6 | hopeless状態のタスクがある状態で別タスクを編集 | （FIX-3採用時）hopeless通知が再発火しない |
| 7 | 編集 → アプリkill → 再起動 | 起動時 resync で通知状態が正。重複なし |
| 8 | 完了→Undo、削除→Undo | resync後に通知が正しく復元される |

### ユニットテストで担保すべき点

- `_notificationId` が異なる taskId に対して**現実的なタスク数で衝突しない**こと
  （ランダムUUIDを1万件生成し、(taskBits<<3 | stateIndex) の重複がゼロ近傍であることを確認）
- `_notificationId(taskId, s)` の戻り値が **0 以上 2147483647 以下**（32bit signed正領域）であること

---

## v1.5との関係（重要な設計メモ）

FIX-1 の「全タスク再スケジュール一本化」は、**v1.5のFEAT-01（マルチタスクslack補正）で必須となる通知アーキテクチャと同一**である。
v1.5では先行タスクの所要時間が他タスクのTGLに影響するため、1件の編集が全タスクの遷移時刻を変える。
したがって本hotfixは v1.5 の通知設計の**前倒し実装**として位置づけられ、v1.5計画書の
「再スケジュール戦略」セクションはこの実装を土台に拡張すればよい。

- v1.4.1：`resyncFromDatabase()` = cancelAll + 全再登録（precedingLoad なし、現行のslack計算のまま）
- v1.5：同じ resync の内部で、締切昇順ソート＋累積和で precedingLoad を加味（通知予算60件管理を追加）

→ v1.4.1で `resyncFromDatabase()` を入れておけば、v1.5ではその中身を差し替えるだけで済む。

---

## 実装チェックリスト

- [ ] 手順0のログで候補A/Bを確定
- [ ] FIX-1：`resyncFromDatabase()` 追加、全ミューテーション箇所を置換（DB書き込み完了→resyncの順序厳守）
- [ ] FIX-2：（候補A確定時）`_notificationId` を28bit+3bit設計に変更。**FIX-1とセットで適用**
- [ ] FIX-3：手順0の結果でhopeless再発火が原因なら対応、そうでなければv1.5送りを明記
- [ ] テストシナリオ1〜8を実機（iOS/Android両方）で確認
- [ ] ユニットテスト（ID衝突・ID範囲）追加
- [ ] 一時挿入した計測ログ（手順0）を削除
- [ ] バージョン番号を 1.4.1 に更新（pubspec.yaml の version、両ストアのビルド番号）

---

## 注意事項

1. リセット処理を「足す」修正はしない（既に実装済み。空振りする）
2. DB書き込みを `await` で完了させてから resync を呼ぶ（順序を逆にすると古い状態で再登録される）
3. FIX-2 は FIX-1 とセット（ID式変更単独は旧式の孤児通知を生む）
4. TGL生数値は引き続き一切表示しない。本hotfixは通知スケジューリングのみを扱い、TGL計算式・状態ラベルには触れない
5. 既存のsoftplus平滑化・二分探索ソルバー・kActiveRatio は変更しない
