import 'package:drift/drift.dart' hide Column;
import 'package:tico/data/database/database.dart';
import 'package:tico/domain/models/pomodoro_session_model.dart';
import 'package:tico/domain/repositories/pomodoro_repository.dart';

class PomodoroRepositoryImpl implements PomodoroRepository {
  final AppDatabase _db;

  PomodoroRepositoryImpl(this._db);

  @override
  Stream<List<PomodoroSessionModel>> watchAllSessions() {
    return _db.pomodoroDao.watchAllSessions().map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Stream<List<PomodoroSessionModel>> watchSessionsByDateRange(
      DateTime start, DateTime end) {
    return _db.pomodoroDao.watchSessionsByDateRange(start, end).map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Stream<List<PomodoroSessionModel>> watchSessionsByTask(String taskId) {
    return _db.pomodoroDao.watchSessionsByTask(taskId).map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  @override
  Future<PomodoroSessionModel> createSession(PomodoroSessionModel session) async {
    final companion = PomodoroSessionsCompanion.insert(
      id: session.id,
      userId: Value(session.userId),
      taskId: Value(session.taskId),
      startTime: session.startTime,
      endTime: Value(session.endTime),
      plannedDuration: session.plannedDuration,
      actualDuration: Value(session.actualDuration),
      type: session.type,
      status: session.status,
    );
    final row = await _db.pomodoroDao.insertSession(companion);
    return _fromRow(row);
  }

  @override
  Future<PomodoroSessionModel> updateSession(PomodoroSessionModel session) async {
    final companion = PomodoroSessionsCompanion(
      id: Value(session.id),
      userId: Value(session.userId),
      taskId: Value(session.taskId),
      startTime: Value(session.startTime),
      endTime: Value(session.endTime),
      plannedDuration: Value(session.plannedDuration),
      actualDuration: Value(session.actualDuration),
      type: Value(session.type),
      status: Value(session.status),
    );
    await _db.pomodoroDao.updateSession(companion);
    return session;
  }

  @override
  Future<void> deleteSession(String id) {
    return _db.pomodoroDao.deleteSession(id);
  }

  @override
  Future<int> getTotalFocusMinutes(DateTime start, DateTime end) {
    return _db.pomodoroDao.getTotalFocusMinutesByDateRange(start, end);
  }

  PomodoroSessionModel _fromRow(PomodoroSession row) {
    return PomodoroSessionModel(
      id: row.id,
      userId: row.userId,
      taskId: row.taskId,
      startTime: row.startTime,
      endTime: row.endTime,
      plannedDuration: row.plannedDuration,
      actualDuration: row.actualDuration,
      type: row.type,
      status: row.status,
      createdAt: row.createdAt,
    );
  }
}