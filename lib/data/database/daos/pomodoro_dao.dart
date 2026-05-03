import 'package:drift/drift.dart';
import '../tables/tables.dart';
import '../app_database.dart';

part 'pomodoro_dao.g.dart';

@DriftAccessor(tables: [PomodoroSessions])
class PomodoroDao extends DatabaseAccessor<AppDatabase> with _$PomodoroDaoMixin {
  PomodoroDao(AppDatabase db) : super(db);

  Stream<List<PomodoroSession>> watchAllSessions() {
    return (select(pomodoroSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.startTime)]))
        .watch();
  }

  Stream<List<PomodoroSession>> watchSessionsByDateRange(DateTime start, DateTime end) {
    return (select(pomodoroSessions)
          ..where((s) => s.startTime.isBetweenValues(start, end))
          ..orderBy([(s) => OrderingTerm.desc(s.startTime)]))
        .watch();
  }

  Stream<List<PomodoroSession>> watchSessionsByTask(String taskId) {
    return (select(pomodoroSessions)
          ..where((s) => s.taskId.equals(taskId))
          ..orderBy([(s) => OrderingTerm.desc(s.startTime)]))
        .watch();
  }

  Future<PomodoroSession> insertSession(PomodoroSessionsCompanion entry) =>
      into(pomodoroSessions).insertReturning(entry);

  Future<bool> updateSession(PomodoroSessionsCompanion entry) =>
      update(pomodoroSessions).replace(entry);

  Future<int> deleteSession(String id) {
    return (delete(pomodoroSessions)..where((s) => s.id.equals(id))).go();
  }

  Future<int> getTotalFocusMinutesByDateRange(DateTime start, DateTime end) async {
    final query = selectOnly(pomodoroSessions)
      ..where(pomodoroSessions.startTime.isBetweenValues(start, end))
      ..where(pomodoroSessions.status.equalsValue(PomodoroStatus.completed))
      ..where(pomodoroSessions.type.equalsValue(PomodoroType.work));
    query.addColumns([pomodoroSessions.actualDuration.sum()]);
    final row = await query.getSingle();
    return row.read(pomodoroSessions.actualDuration.sum()) ?? 0;
  }
}