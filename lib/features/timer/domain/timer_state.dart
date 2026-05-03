import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../data/database/tables/tables.dart';
import '../../../domain/models/timer_settings.dart';
import '../../../domain/models/pomodoro_session_model.dart';

enum TimerMode { work, shortBreak, longBreak }

class TimerState {
  final TimerMode mode;
  final int timeLeft;
  final bool isActive;
  final String? activeTaskId;

  const TimerState({
    this.mode = TimerMode.work,
    required this.timeLeft,
    this.isActive = false,
    this.activeTaskId,
  });

  TimerState copyWith({
    TimerMode? mode,
    int? timeLeft,
    bool? isActive,
    String? activeTaskId,
  }) {
    return TimerState(
      mode: mode ?? this.mode,
      timeLeft: timeLeft ?? this.timeLeft,
      isActive: isActive ?? this.isActive,
      activeTaskId: activeTaskId ?? this.activeTaskId,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  final Ref _ref;
  Timer? _timer;
  TimerSettings _settings;
  int _completedWorkToday = 0;

  TimerNotifier(this._ref, {required TimerSettings settings})
      : _settings = settings,
        super(TimerState(timeLeft: settings.workDuration * 60)) {
    _loadTodayCount();
  }

  Future<void> _loadTodayCount() async {
    final repo = _ref.read(pomodoroRepositoryProvider);
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final minutes = await repo.getTotalFocusMinutes(start, end);
    // estimate count from minutes (rough)
    _completedWorkToday = (minutes / _settings.workDuration).round();
  }

  void updateSettings(TimerSettings settings) {
    _settings = settings;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (_timer != null && _timer!.isActive) return;
    state = state.copyWith(isActive: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isActive || state.timeLeft <= 0) {
        _timer?.cancel();
        _timer = null;
        return;
      }
      final newTimeLeft = state.timeLeft - 1;
      state = state.copyWith(timeLeft: newTimeLeft);
      if (newTimeLeft <= 0) {
        _handleComplete();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isActive: false);
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    final duration = _getDurationByMode(state.mode);
    state = state.copyWith(timeLeft: duration, isActive: false);
  }

  void switchMode(TimerMode mode) {
    _timer?.cancel();
    _timer = null;
    final duration = _getDurationByMode(mode);
    state = state.copyWith(mode: mode, timeLeft: duration, isActive: false);
  }

  void setActiveTaskId(String? id) {
    state = state.copyWith(activeTaskId: id);
  }

  int _getDurationByMode(TimerMode m) {
    return switch (m) {
      TimerMode.work => _settings.workDuration * 60,
      TimerMode.shortBreak => _settings.shortBreakDuration * 60,
      TimerMode.longBreak => _settings.longBreakDuration * 60,
    };
  }

  Future<void> _handleComplete() async {
    _timer?.cancel();
    _timer = null;

    final completedType = state.mode == TimerMode.work
        ? PomodoroType.work
        : state.mode == TimerMode.shortBreak
            ? PomodoroType.shortBreak
            : PomodoroType.longBreak;
    final plannedDuration = _getDurationByMode(state.mode) ~/ 60;

    final repo = _ref.read(pomodoroRepositoryProvider);
    await repo.createSession(PomodoroSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: state.activeTaskId,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(seconds: plannedDuration * 60)),
      plannedDuration: plannedDuration,
      actualDuration: plannedDuration * 60,
      type: completedType,
      status: PomodoroStatus.completed,
    ));

    if (state.mode == TimerMode.work && state.activeTaskId != null) {
      final tasks = _ref.read(tasksNotifierProvider);
      final task = tasks.where((t) => t.id == state.activeTaskId).firstOrNull;
      if (task != null) {
        await _ref.read(tasksNotifierProvider.notifier).incrementPomodoro(task);
      }
      _completedWorkToday++;
    }

    if (state.mode == TimerMode.work) {
      if (_completedWorkToday % _settings.longBreakInterval == 0) {
        switchMode(TimerMode.longBreak);
      } else {
        switchMode(TimerMode.shortBreak);
      }
    } else {
      switchMode(TimerMode.work);
    }
  }
}

final timerStateProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final settings = ref.watch(timerSettingsProvider);
  return TimerNotifier(ref, settings: settings);
});