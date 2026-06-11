import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../models/task.dart';
import '../models/tgl_state.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/tgl_calculator.dart';
import '../widgets/adaptive/adaptive_app_bar.dart';
import '../widgets/adaptive/adaptive_button.dart';
import '../widgets/task_form_widgets.dart';
import 'task_list_screen.dart' show TaskStatePill;

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});
  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TextEditingController _titleController;
  late TaskType _selectedType;
  late DateTime _deadline;
  late int _timeIndex;
  late int _avoidance;

  static const int _timeStepMinutes = 15;
  static const int _timeSteps = 96;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t.title);
    _selectedType = t.type;
    _deadline = t.deadline;
    _timeIndex = ((t.requiredHours * 60) / _timeStepMinutes).round() - 1;
    _avoidance = t.avoidance;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  double get _requiredHours => (_timeIndex + 1) * _timeStepMinutes / 60.0;

  String _formatTime(int index) {
    final l = AppLocalizations.of(context)!;
    final minutes = (index + 1) * _timeStepMinutes;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return l.timeUnitMinutes(m);
    if (m == 0) return l.timeUnitHours(h);
    return l.timeUnitHoursMinutes(h, m);
  }

  Future<void> _pickDeadline() async {
    final l = AppLocalizations.of(context)!;
    final minDate = DateTime.now().subtract(const Duration(minutes: 1));
    final initial = _deadline.isBefore(minDate) ? minDate : _deadline;
    DateTime picked = initial;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: Text(l.doneButton),
                onPressed: () {
                  setState(() => _deadline = picked);
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: initial,
                minimumDate: minDate,
                use24hFormat: true,
                onDateTimeChanged: (dt) => picked = dt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.taskNameRequired)),
      );
      return;
    }

    final task = widget.task;
    task
      ..id = widget.task.id.isNotEmpty ? widget.task.id : const Uuid().v4()
      ..title = title
      ..deadline = _deadline
      ..requiredHours = _requiredHours
      ..type = _selectedType
      ..avoidance = _avoidance
      ..deletedAt = widget.task.deletedAt
      ..completedAt = widget.task.completedAt;

    await DatabaseService.saveTask(task);
    await NotificationService.scheduleNotificationsForTask(task);

    if (mounted) Navigator.pop(context);
  }

  Future<void> _complete() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final taskId = widget.task.id;
    await DatabaseService.markCompleted(taskId);
    await NotificationService.cancelNotificationsForTask(taskId);
    if (!mounted) return;
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.taskCompletedMessage),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l.undoButton,
          onPressed: () async {
            await DatabaseService.undoComplete(taskId);
            final t = await DatabaseService.getTaskByUuid(taskId);
            if (t != null) {
              await NotificationService.scheduleNotificationsForTask(t);
            }
          },
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final taskId = widget.task.id;
    await NotificationService.cancelNotificationsForTask(taskId);
    await DatabaseService.softDeleteTask(taskId);
    if (!mounted) return;
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.taskDeletedMessage),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l.undoButton,
          onPressed: () async {
            await DatabaseService.undoDeleteTask(taskId);
            final t = await DatabaseService.getTaskByUuid(taskId);
            if (t != null) {
              await NotificationService.scheduleNotificationsForTask(t);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = taskToState(widget.task);
    final isOverdue = state == TGLState.overdue;

    final deadlineText =
        '${_deadline.year}/${_deadline.month.toString().padLeft(2, '0')}/${_deadline.day.toString().padLeft(2, '0')} '
        '${_deadline.hour.toString().padLeft(2, '0')}:${_deadline.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: adaptiveAppBar(
        title: l.taskDetailTitle,
        leading: adaptiveTextButton(
          text: l.cancelButton,
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: l.completeButton,
            onPressed: _complete,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l.deleteButton,
            onPressed: _delete,
          ),
          adaptiveTextButton(
            text: l.saveTaskButton,
            onPressed: _submit,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 状態ヘッダーバナー
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? const Color(0xFF7F1D1D)
                      : const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    TaskStatePill(state: state),
                    const SizedBox(width: 10),
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isOverdue ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TaskFormCard(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: l.taskNamePlaceholder,
                    border: InputBorder.none,
                    labelText: l.taskNameLabel,
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 12),

              TaskFormSectionLabel(l.taskTypeLabel),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: TaskType.values.map((type) {
                  final selected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type.label(context)),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedType = type),
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontSize: 13,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              TaskFormSectionLabel(l.deadlineLabel),
              const SizedBox(height: 6),
              TaskFormCard(
                child: InkWell(
                  onTap: _pickDeadline,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(deadlineText, style: const TextStyle(fontSize: 16)),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TaskFormSectionLabel(l.timeAndAvoidanceLabel),
              const SizedBox(height: 6),
              TaskFormCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            l.requiredTimeLabel,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          TaskFormDrumDial(
                            itemCount: _timeSteps,
                            selectedIndex: _timeIndex,
                            labelBuilder: _formatTime,
                            onChanged: (i) => setState(() => _timeIndex = i),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 170, color: Colors.grey.shade200),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            l.avoidanceLevelLabel,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          TaskFormDrumDial(
                            itemCount: 10,
                            selectedIndex: _avoidance - 1,
                            labelBuilder: (i) => '${i + 1}',
                            sublabelBuilder: (i) => avoidanceLabelFor(context, i + 1),
                            onChanged: (i) => setState(() => _avoidance = i + 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
