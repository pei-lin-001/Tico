import 'package:tico/domain/models/pomodoro_session_model.dart';

abstract class PomodoroRepository {
  Stream<List<PomodoroSessionModel>> watchAllSessions();
  Stream<List<PomodoroSessionModel>> watchSessionsByDateRange(DateTime start, DateTime end);
  Stream<List<PomodoroSessionModel>> watchSessionsByTask(String taskId);
  Future<PomodoroSessionModel> createSession(PomodoroSessionModel session);
  Future<PomodoroSessionModel> updateSession(PomodoroSessionModel session);
  Future<void> deleteSession(String id);
  Future<int> getTotalFocusMinutes(DateTime start, DateTime end);
}