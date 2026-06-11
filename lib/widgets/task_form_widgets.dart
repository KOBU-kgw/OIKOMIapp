import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

String avoidanceLabelFor(BuildContext context, int level) {
  final l = AppLocalizations.of(context)!;
  switch (level) {
    case 1:  return l.avoidance1;
    case 2:  return l.avoidance2;
    case 3:  return l.avoidance3;
    case 4:  return l.avoidance4;
    case 5:  return l.avoidance5;
    case 6:  return l.avoidance6;
    case 7:  return l.avoidance7;
    case 8:  return l.avoidance8;
    case 9:  return l.avoidance9;
    case 10: return l.avoidance10;
    default: return '';
  }
}

class TaskFormSectionLabel extends StatelessWidget {
  const TaskFormSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
      );
}

class TaskFormCard extends StatelessWidget {
  const TaskFormCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: child,
      );
}

class TaskFormDrumDial extends StatefulWidget {
  const TaskFormDrumDial({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.labelBuilder,
    required this.onChanged,
    this.sublabelBuilder,
  });

  final int itemCount;
  final int selectedIndex;
  final String Function(int index) labelBuilder;
  final String? Function(int index)? sublabelBuilder;
  final ValueChanged<int> onChanged;

  @override
  State<TaskFormDrumDial> createState() => _TaskFormDrumDialState();
}

class _TaskFormDrumDialState extends State<TaskFormDrumDial> {
  late FixedExtentScrollController _controller;

  static const double _height = 150;
  static const double _itemExtent = 38;
  static const double _fadeSize = 45;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(TaskFormDrumDial old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex &&
        _controller.selectedItem != widget.selectedIndex) {
      _controller.jumpToItem(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle _textStyle(int index) {
    final diff = (index - widget.selectedIndex).abs();
    if (diff == 0) {
      return const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      );
    } else if (diff == 1) {
      return TextStyle(fontSize: 16, color: Colors.grey.shade500);
    } else {
      return TextStyle(fontSize: 15, color: Colors.grey.shade400);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0.0, _fadeSize / _height, 1.0 - _fadeSize / _height, 1.0],
            ).createShader(rect),
            blendMode: BlendMode.dstIn,
            child: SizedBox(
              height: _height,
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: _itemExtent,
                perspective: 0.003,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (i) {
                  HapticFeedback.selectionClick();
                  widget.onChanged(i);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.itemCount,
                  builder: (context, index) {
                    final sublabel = widget.sublabelBuilder?.call(index);
                    return Center(
                      child: sublabel != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(widget.labelBuilder(index), style: _textStyle(index)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    sublabel,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: index == widget.selectedIndex
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Text(widget.labelBuilder(index), style: _textStyle(index)),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: (_height - _itemExtent) / 2,
            left: 4,
            right: 4,
            child: IgnorePointer(
              child: Container(
                height: _itemExtent,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
