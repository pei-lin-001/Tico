import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tico/data/database/tables/tables.dart' show PomodoroType, PomodoroStatus;

part 'pomodoro_session_model.freezed.dart';
part 'pomodoro_session_model.g.dart';

@freezed
class PomodoroSessionModel with _$PomodoroSessionModel {
  const factory PomodoroSessionModel({
    required String id,
    String? userId,
    String? taskId,
    required DateTime startTime,
    DateTime? endTime,
    required int plannedDuration,
    int? actualDuration,
    required PomodoroType type,
    required PomodoroStatus status,
    DateTime? createdAt,
  }) = _PomodoroSessionModel;

  factory PomodoroSessionModel.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSessionModelFromJson(json);
}