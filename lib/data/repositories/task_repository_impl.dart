import 'package:drift/drift.dart' hide Column;
import 'package:tico/data/database/database.dart';
import 'package:tico/domain/models/task_model.dart';
import 'package:tico/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase _db;

  TaskRepositoryImpl(this._db);

  @override
  Stream<List<TaskModel>> watchActiveTasks() {
    return _db.taskDao.watchActiveTasks().map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Stream<List<TaskModel>> watchCompletedTasks() {
    return _db.taskDao.watchCompletedTasks().map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Stream<List<TaskModel>> watchAllTasks() {
    return _db.taskDao.watchAllTasks().map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final companion = TasksCompanion.insert(
      id: task.id,
      userId: Value(task.userId),
      title: task.title,
      description: Value(task.description),
      estimatedPomodoros: Value(task.estimatedPomodoros),
      completedPomodoros: Value(task.completedPomodoros),
      isCompleted: Value(task.isCompleted),
      priority: Value(task.priority.index),
      sortOrder: Value(task.sortOrder),
    );
    final row = await _db.taskDao.insertTask(companion);
    return _fromRow(row);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final companion = TasksCompanion(
      id: Value(task.id),
      userId: Value(task.userId),
      title: Value(task.title),
      description: Value(task.description),
      estimatedPomodoros: Value(task.estimatedPomodoros),
      completedPomodoros: Value(task.completedPomodoros),
      isCompleted: Value(task.isCompleted),
      priority: Value(task.priority.index),
      sortOrder: Value(task.sortOrder),
      updatedAt: Value(DateTime.now()),
    );
    await _db.taskDao.updateTask(companion);
    return task;
  }

  @override
  Future<void> deleteTask(String id) {
    return _db.taskDao.deleteTask(id);
  }

  @override
  Future<void> markCompleted(String id, bool completed) async {
    final companion = TasksCompanion(
      id: Value(id),
      isCompleted: Value(completed),
      updatedAt: Value(DateTime.now()),
    );
    await _db.taskDao.updateTask(companion);
  }

  @override
  Future<void> incrementCompletedPomodoros(String id) async {
    final companion = TasksCompanion(
      id: Value(id),
      completedPomodoros: Value(0),
      updatedAt: Value(DateTime.now()),
    );
    await _db.taskDao.updateTask(companion);
  }

  TaskModel _fromRow(Task row) {
    return TaskModel(
      id: row.id,
      userId: row.userId,
      title: row.title,
      description: row.description,
      estimatedPomodoros: row.estimatedPomodoros,
      completedPomodoros: row.completedPomodoros,
      isCompleted: row.isCompleted,
      priority: TaskPriority.values[row.priority],
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}