import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_extensions.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../widgets/adaptive/adaptive_app_bar.dart';
import '../widgets/adaptive/adaptive_button.dart';
import '../widgets/task_form_widgets.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});

  /// null → 追加モード、非null → 編集モード
  final Task? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final TextEditingController _titleController;
  late TaskType _selectedType;
  late DateTime _deadline;
  late int _timeIndex;  // 0-based: index 0 = 15分
  late int _avoidance;  // 1〜10

  bool get _isEditing => widget.task != null;

  static const int _timeStepMinutes = 15;
  static const int _timeSteps = 96; // 15min〜24h

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _selectedType = t?.type ?? TaskType.report;
    _deadline = t?.deadline ?? DateTime.now();
    _timeIndex = t != null
        ? ((t.requiredHours * 60) / _timeStepMinutes).round() - 1
        : 3; // デフォルト60分
    _avoidance = t?.avoidance ?? 5;
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
    if (Platform.isIOS) {
      DateTime selected = initial;
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => Container(
          height: 320,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: Text(l.doneButton),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: initial,
                  minimumDate: minDate,
                  maximumDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  use24hFormat: true,
                  onDateTimeChanged: (dt) => selected = dt,
                ),
              ),
            ],
          ),
        ),
      );
      if (mounted) setState(() => _deadline = selected);
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: minDate,
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      );
      if (date == null || !mounted) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadline),
      );
      if (time == null || !mounted) return;

      setState(() {
        _deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
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

    final task = widget.task ?? Task();
    task
      ..id = widget.task?.id ?? const Uuid().v4()
      ..title = title
      ..deadline = _deadline
      ..requiredHours = _requiredHours
      ..type = _selectedType
      ..avoidance = _avoidance
      ..isCompleted = widget.task?.isCompleted ?? false
      ..createdAt = widget.task?.createdAt ?? DateTime.now()
      ..deletedAt = widget.task?.deletedAt
      ..completedAt = widget.task?.completedAt;

    try {
      await DatabaseService.saveTask(task);
      await NotificationService.resyncFromDatabase();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final deadlineText =
        '${_deadline.year}/${_deadline.month.toString().padLeft(2, '0')}/${_deadline.day.toString().padLeft(2, '0')} '
        '${_deadline.hour.toString().padLeft(2, '0')}:${_deadline.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: adaptiveAppBar(
        title: _isEditing ? l.editTaskTitle : l.addTaskTitle,
        leading: adaptiveTextButton(
          text: l.cancelButton,
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  child: Text(_isEditing ? l.saveTaskButton : l.addTaskButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
