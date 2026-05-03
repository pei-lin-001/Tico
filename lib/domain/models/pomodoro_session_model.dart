import 'package:tico/data/database/tables/tables.dart'
    show PomodoroType, PomodoroStatus;

class PomodoroSessionModel {
  final String id;
  final String? taskId;
  final DateTime startTime;
  final DateTime? endTime;
  final int plannedDuration;
  final int? actualDuration;
  final PomodoroType type;
  final PomodoroStatus status;
  final DateTime? createdAt;

  const PomodoroSessionModel({
    required this.id,
    this.taskId,
    required this.startTime,
    this.endTime,
    required this.plannedDuration,
    this.actualDuration,
    required this.type,
    required this.status,
    this.createdAt,
  });

  PomodoroSessionModel copyWith({
    String? id,
    String? taskId,
    DateTime? startTime,
    DateTime? endTime,
    int? plannedDuration,
    int? actualDuration,
    PomodoroType? type,
    PomodoroStatus? status,
    DateTime? createdAt,
  }) {
    return PomodoroSessionModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}