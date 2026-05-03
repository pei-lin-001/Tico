import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskPriority { none, low, medium, high }

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    String? userId,
    required String title,
    @Default('') String description,
    @Default(1) int estimatedPomodoros,
    @Default(0) int completedPomodoros,
    @Default(false) bool isCompleted,
    @Default(TaskPriority.none) TaskPriority priority,
    @Default(0) int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}