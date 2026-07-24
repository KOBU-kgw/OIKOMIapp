import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../models/tgl_state.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/tgl_calculator.dart';
import '../services/threshold_editor_logic.dart';
import '../services/threshold_provider.dart';
import '../widgets/adaptive/adaptive_app_bar.dart';
import 'purchase_screen.dart';
import 'task_list_screen.dart' show TaskStatePill;

/// カスタム閾値エディタ。
///
/// [readOnly] = true の場合は転換導線（FEAT-03）のプレビューモード:
/// スライダーは動かせるが、保存しようとすると購入画面へ誘導する。
class ThresholdEditorScreen extends StatefulWidget {
  const ThresholdEditorScreen({super.key, this.readOnly = false});
  final bool readOnly;

  @override
  State<ThresholdEditorScreen> createState() => _ThresholdEditorScreenState();
}

class _ThresholdEditorScreenState extends State<ThresholdEditorScreen> {
  // index順: peaceful, someday, reality, noEscape
  List<double> _values = [
    TGLThresholds.peaceful,
    TGLThresholds.someday,
    TGLThresholds.reality,
    TGLThresholds.noEscape,
  ];
  bool _useCustom = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pref = await DatabaseService.getUserPreference();
    if (!mounted) return;
    setState(() {
      _values = [pref.peaceful, pref.someday, pref.reality, pref.noEscape];
      // 未購入プレビューでは常にON扱い（体験目的）。購入済みは保存値に従う。
      _useCustom = widget.readOnly || pref.useCustomThresholds;
      _loaded = true;
    });
  }

  TGLThresholdSet get _previewSet => _useCustom
      ? TGLThresholdSet(
          peaceful: _values[0],
          someday: _values[1],
          reality: _values[2],
          noEscape: _values[3],
        )
      : TGLThresholdSet.defaults;

  void _reset() {
    setState(() {
      _values = [
        TGLThresholds.peaceful,
        TGLThresholds.someday,
        TGLThresholds.reality,
        TGLThresholds.noEscape,
      ];
    });
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (widget.readOnly) {
      // プレビューモード: 保存しようとした時点で購入画面へ
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PurchaseScreen()),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final pref = await DatabaseService.getUserPreference();
    pref
      ..customPeaceful = _values[0]
      ..customSomeday = _values[1]
      ..customReality = _values[2]
      ..customNoEscape = _values[3]
      ..useCustomThresholds = _useCustom;
    await DatabaseService.saveUserPreference(pref);
    // 保存（コミット）時のみ反映・通知再スケジュール（スライダー操作ごとには行わない）
    await ThresholdProvider.reload();
    NotificationService.requestResync();

    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(l.thresholdSaved)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sliderLabels = [
      l.thresholdLabelPeaceful,
      l.thresholdLabelSomeday,
      l.thresholdLabelReality,
      l.thresholdLabelNoEscape,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: adaptiveAppBar(
        title: widget.readOnly
            ? l.thresholdEditorPreviewTitle
            : l.thresholdEditorTitle,
        actions: [
          TextButton(
            onPressed: _loaded ? _save : null,
            child: Text(l.thresholdSave),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l.thresholdEditorIntro,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                if (!widget.readOnly)
                  _Card(
                    child: SwitchListTile.adaptive(
                      value: _useCustom,
                      onChanged: (v) => setState(() => _useCustom = v),
                      title: Text(l.thresholdEditorUseCustom),
                      activeTrackColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                const SizedBox(height: 8),

                _Card(
                  child: Column(
                    children: [
                      for (int i = 0; i < 4; i++) ...[
                        if (i > 0) const Divider(height: 20),
                        _ThresholdSlider(
                          label: sliderLabels[i],
                          value: _values[i],
                          range: kThresholdRanges[i],
                          enabled: _useCustom,
                          onChanged: (v) => setState(() {
                            _values[i] = clampThreshold(i, v, _values);
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _useCustom ? _reset : null,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(l.thresholdReset),
                  ),
                ),
                const SizedBox(height: 16),

                // ライブプレビュー: 状態ラベルのみ（TGL生値は絶対に表示しない）
                Text(
                  l.thresholdPreviewHint,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                _Card(
                  child: Column(
                    children: [
                      _PreviewRow(
                        title: l.thresholdSampleTaskNear,
                        task: _sampleTask(hoursLeft: 24, t: 5, m: 8),
                        thresholds: _previewSet,
                      ),
                      const Divider(height: 20),
                      _PreviewRow(
                        title: l.thresholdSampleTaskMid,
                        task: _sampleTask(hoursLeft: 72, t: 4, m: 6),
                        thresholds: _previewSet,
                      ),
                      const Divider(height: 20),
                      _PreviewRow(
                        title: l.thresholdSampleTaskFar,
                        task: _sampleTask(hoursLeft: 168, t: 2, m: 3),
                        thresholds: _previewSet,
                      ),
                    ],
                  ),
                ),

                if (widget.readOnly) ...[
                  const SizedBox(height: 16),
                  Text(
                    l.thresholdPreviewLockedNote,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  static Task _sampleTask(
      {required int hoursLeft, required double t, required int m}) {
    return Task()
      ..id = 'sample'
      ..title = 'sample'
      ..deadline = DateTime.now().add(Duration(hours: hoursLeft))
      ..requiredHours = t
      ..avoidance = m
      ..isCompleted = false
      ..createdAt = DateTime.now()
      ..type = TaskType.report;
  }
}

class _ThresholdSlider extends StatelessWidget {
  const _ThresholdSlider({
    required this.label,
    required this.value,
    required this.range,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ThresholdRange range;
  final bool enabled;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Slider.adaptive(
          value: value.clamp(range.min, range.max),
          min: range.min,
          max: range.max,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.title,
    required this.task,
    required this.thresholds,
  });

  final String title;
  final Task task;
  final TGLThresholdSet thresholds;

  @override
  Widget build(BuildContext context) {
    final state = taskToState(task, thresholds: thresholds);
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
        TaskStatePill(state: state),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
