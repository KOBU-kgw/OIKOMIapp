import 'package:flutter/widgets.dart';
import '../models/task.dart';
import '../models/tgl_state.dart';
import 'app_localizations.dart';

extension TGLStateL10n on TGLState {
  String label(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (this) {
      case TGLState.peaceful: return l.tglStatePeaceful;
      case TGLState.someday:  return l.tglStateSomeday;
      case TGLState.reality:  return l.tglStateReality;
      case TGLState.noEscape: return l.tglStateNoEscape;
      case TGLState.war:      return l.tglStateWar;
      case TGLState.overdue:  return l.tglStateOverdue;
    }
  }
}

extension TaskTypeL10n on TaskType {
  String label(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (this) {
      case TaskType.miniReport:   return l.taskTypeMiniReport;
      case TaskType.report:       return l.taskTypeReport;
      case TaskType.quizStudy:    return l.taskTypeQuizStudy;
      case TaskType.presentation: return l.taskTypePresentation;
      case TaskType.finalExam:    return l.taskTypeFinalExam;
    }
  }
}
