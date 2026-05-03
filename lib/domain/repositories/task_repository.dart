import 'package:tico/domain/models/task_model.dart';

abstract class TaskRepository {
  Stream<List<TaskModel>> watchActiveTasks();
  Stream<List<TaskModel>> watchCompletedTasks();
  Stream<List<TaskModel>> watchAllTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}