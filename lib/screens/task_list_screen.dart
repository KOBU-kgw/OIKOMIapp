import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_version.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../models/task.dart';
import '../models/task_sort_order.dart';
import '../models/tgl_state.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/task_sorter.dart';
import '../services/tgl_calculator.dart';
import '../widgets/adaptive/adaptive_app_bar.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import 'settings_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskSortOrder _sortOrder = TaskSortOrder.tgl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWhatsNewIfNeeded());
  }

  Future<void> _showWhatsNewIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString('last_seen_version');
    if (lastSeen == kCurrentVersion) return;

    if (!mounted) return;
    final l = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.whatsNewTitle(kCurrentVersion)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notifications_active, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(l.whatsNewItem1)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.sort, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(l.whatsNewItem2)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.whatsNewClose),
          ),
        ],
      ),
    );

    await prefs.setString('last_seen_version', kCurrentVersion);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: adaptiveAppBar(
        title: l.taskListTitle,
        actions: [
          IconButton(
            icon: Icon(
              _sortOrder == TaskSortOrder.tgl
                  ? Icons.warning_amber_rounded
                  : Icons.access_time_rounded,
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
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskFormScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: DatabaseService.watchIncompleteTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final (overdue: overdueTasks, active: activeTasks) =
              partitionAndSortTasks(snapshot.data!, _sortOrder);

          if (overdueTasks.isEmpty && activeTasks.isEmpty) {
            return Center(
              child: Text(
                l.taskListEmpty,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final List<Widget> items = [];
          if (overdueTasks.isNotEmpty) {
            items.add(_SectionHeader(
              l.tglStateOverdue,
              color: const Color(0xFF7F1D1D),
              key: const ValueKey('overdue-header'),
            ));
            items.addAll(overdueTasks.map((t) => _TaskCard(key: ValueKey(t.id), task: t)));
          }
          items.addAll(activeTasks.map((t) => _TaskCard(key: ValueKey(t.id), task: t)));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          );
        },
      ),
    );
  }
}

// ─── Task Card ────────────────────────────────────────────────

class _TaskCard extends StatefulWidget {
  const _TaskCard({super.key, required this.task});
  final Task task;

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  double _dragOffset = 0;
  bool _revealed = false;
  static const double _revealWidth = 70.0; // 完了ボタン 1つ × 70px

  void _closeMenu() => setState(() {
        _dragOffset = 0;
        _revealed = false;
      });

  Future<void> _complete() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final taskId = widget.task.id;
    await DatabaseService.markCompleted(taskId);
    await NotificationService.resyncFromDatabase();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.taskCompletedMessage),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l.undoButton,
          onPressed: () async {
            await DatabaseService.undoComplete(taskId);
            await NotificationService.resyncFromDatabase();
          },
        ),
      ),
    );
  }

  String _formatHours(double hours) {
    final l = AppLocalizations.of(context)!;
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h == 0) return l.timeUnitMinutes(m);
    if (m == 0) return l.timeUnitHours(h);
    return l.timeUnitHoursMinutes(h, m);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final task = widget.task;
    final state = taskToState(task);
    final isHighAlert = state == TGLState.noEscape ||
        state == TGLState.war ||
        state == TGLState.overdue;

    final deadlineText =
        '${task.deadline.month}/${task.deadline.day} '
        '${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // 背景アクションボタン（完了のみ）
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButton(
                    label: l.swipeComplete,
                    color: Colors.green,
                    onTap: _complete,
                  ),
                ],
              ),
            ),
            // カード本体
            GestureDetector(
              onHorizontalDragUpdate: (d) {
                setState(() {
                  _dragOffset = (_dragOffset + d.delta.dx).clamp(-_revealWidth, 0.0);
                });
              },
              onHorizontalDragEnd: (_) {
                setState(() {
                  if (_dragOffset < -_revealWidth / 2) {
                    _dragOffset = -_revealWidth;
                    _revealed = true;
                  } else {
                    _dragOffset = 0;
                    _revealed = false;
                  }
                });
              },
              onTap: () {
                if (_revealed) {
                  _closeMenu();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(task: widget.task),
                    ),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_dragOffset, 0, 0),
                decoration: BoxDecoration(
                  color: isHighAlert ? const Color(0xFFFFF0F0) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: isHighAlert
                      ? Border.all(color: Colors.red.shade200, width: 1.5)
                      : null,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${task.type.label(context)}　M=${task.avoidance}　${_formatHours(task.requiredHours)}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TaskStatePill(state: state),
                        const SizedBox(height: 6),
                        Text(
                          deadlineText,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        color: color,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label, {super.key, this.color = Colors.grey});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
        ),
      );
}

// ─── State Pill ───────────────────────────────────────────────

class TaskStatePill extends StatelessWidget {
  const TaskStatePill({super.key, required this.state});
  final TGLState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        state.label(context),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _textColor(),
        ),
      ),
    );
  }

  Color _bgColor() {
    switch (state) {
      case TGLState.peaceful: return const Color(0xFFD4EDDA);
      case TGLState.someday:  return const Color(0xFFFFF3CD);
      case TGLState.reality:  return const Color(0xFFFFE0B2);
      case TGLState.noEscape: return const Color(0xFFFFCDD2);
      case TGLState.war:      return const Color(0xFFB71C1C);
      case TGLState.overdue:  return const Color(0xFF7F1D1D);
    }
  }

  Color _textColor() {
    switch (state) {
      case TGLState.peaceful: return const Color(0xFF155724);
      case TGLState.someday:  return const Color(0xFF856404);
      case TGLState.reality:  return const Color(0xFFE65100);
      case TGLState.noEscape: return const Color(0xFFC62828);
      case TGLState.war:      return Colors.white;
      case TGLState.overdue:  return Colors.white;
    }
  }
}
