import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' show WidgetRef;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/database.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/repositories/pomodoro_repository_impl.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/timer_settings.dart';
import '../../domain/models/pomodoro_session_model.dart';
import '../../data/database/tables/tables.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) {
  return TaskRepositoryImpl(ref.watch(appDatabaseProvider));
});

final pomodoroRepositoryProvider = Provider<PomodoroRepositoryImpl>((ref) {
  return PomodoroRepositoryImpl(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SettingsRepository(prefs);
});

final timerSettingsProvider = StateNotifierProvider<TimerSettingsNotifier, TimerSettings>((ref) {
  return TimerSettingsNotifier(ref);
});

class TimerSettingsNotifier extends StateNotifier<TimerSettings> {
  final Ref _ref;
  TimerSettingsNotifier(this._ref) : super(const TimerSettings()) {
    _load();
  }

  void _load() {
    _ref.read(settingsRepositoryProvider).whenData((repo) {
      state = repo.getTimerSettings();
    });
  }

  Future<void> update(TimerSettings settings) async {
    state = settings;
    await _ref.read(settingsRepositoryProvider).whenData((repo) async {
      await repo.saveTimerSettings(settings);
    });
  }
}

final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, List<TaskModel>>((ref) {
  return TasksNotifier(ref);
});

class TasksNotifier extends StateNotifier<List<TaskModel>> {
  final Ref _ref;
  Stream<List<TaskModel>>? _stream;
  Stream<List<TaskModel>>? _activeStream;

  TasksNotifier(this._ref) : super([]) {
    _init();
  }

  void _init() {
    final repo = _ref.read(taskRepositoryProvider);
    _stream = repo.watchAllTasks();
    _stream!.listen((tasks) {
      if (mounted) state = tasks;
    });
  }

  Future<void> addTask(String title, int totalPomodoros) async {
    final repo = _ref.read(taskRepositoryProvider);
    await repo.createTask(TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      totalPomodoros: totalPomodoros,
    ));
  }

  Future<void> toggleComplete(TaskModel task) async {
    final repo = _ref.read(taskRepositoryProvider);
    await repo.updateTask(task.copyWith(completed: !task.completed));
  }

  Future<void> incrementPomodoro(TaskModel task) async {
    final repo = _ref.read(taskRepositoryProvider);
    final newPomodoros = task.pomodoros + 1;
    final completed = newPomodoros >= task.totalPomodoros;
    await repo.updateTask(task.copyWith(
      pomodoros: newPomodoros,
      completed: completed,
    ));
  }

  Future<void> deleteTask(String id) async {
    final repo = _ref.read(taskRepositoryProvider);
    await repo.deleteTask(id);
  }
}

final pomodoroSessionsProvider = StreamProvider<List<PomodoroSessionModel>>((ref) {
  return ref.watch(pomodoroRepositoryProvider).watchAllSessions();
});

Future<void> recordPomodoroSession(
  WidgetRef ref, {
  required PomodoroType type,
  String? taskId,
  required int plannedDuration,
  int? actualDuration,
}) async {
  final repo = ref.read(pomodoroRepositoryProvider);
  await repo.createSession(PomodoroSessionModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    taskId: taskId,
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(seconds: actualDuration ?? plannedDuration * 60)),
    plannedDuration: plannedDuration,
    actualDuration: actualDuration ?? plannedDuration * 60,
    type: type,
    status: PomodoroStatus.completed,
  ));
}