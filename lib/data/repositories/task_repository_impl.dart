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
      userId: Value(null),
      title: task.title,
      description: const Value(''),
      estimatedPomodoros: Value(task.totalPomodoros),
      completedPomodoros: Value(task.pomodoros),
      isCompleted: Value(task.completed),
      priority: const Value(0),
      sortOrder: const Value(0),
    );
    final row = await _db.taskDao.insertTask(companion);
    return _fromRow(row);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final companion = TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      estimatedPomodoros: Value(task.totalPomodoros),
      completedPomodoros: Value(task.pomodoros),
      isCompleted: Value(task.completed),
      updatedAt: Value(DateTime.now()),
    );
    await _db.taskDao.updateTask(companion);
    return task;
  }

  @override
  Future<void> deleteTask(String id) {
    return _db.taskDao.deleteTask(id);
  }

  TaskModel _fromRow(Task row) {
    return TaskModel(
      id: row.id,
      title: row.title,
      completed: row.isCompleted,
      pomodoros: row.completedPomodoros,
      totalPomodoros: row.estimatedPomodoros,
    );
  }
}