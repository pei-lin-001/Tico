import 'package:tico/domain/models/models.dart';

abstract class TaskRepository {
  Stream<List<TaskModel>> watchActiveTasks();
  Stream<List<TaskModel>> watchCompletedTasks();
  Stream<List<TaskModel>> watchAllTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> markCompleted(String id, bool completed);
  Future<void> incrementCompletedPomodoros(String id);
}