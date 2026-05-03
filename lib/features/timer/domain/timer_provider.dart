import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tico/domain/models/timer_settings.dart';
import 'timer_state.dart';

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(TimerNotifier.new);

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  DateTime? _lastTick;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const TimerState();
  }

  void start() {
    if (state.isIdle || state.isPaused) {
      _lastTick = DateTime.now();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
      state = state.copyWith(status: TimerStateStatus.running);
    }
  }

  void pause() {
    if (state.isRunning) {
      _timer?.cancel();
      state = state.copyWith(status: TimerStateStatus.paused);
    }
  }

  void reset() {
    _timer?.cancel();
    final settings = ref.read(timerSettingsProvider);
    final duration = _getPhaseDuration(state.phase, settings);
    state = TimerState(
      phase: state.phase,
      remainingSeconds: duration,
      totalSeconds: duration,
      completedPomodoros: state.completedPomodoros,
      activeTaskId: state.activeTaskId,
    );
  }

  void skip() {
    _timer?.cancel();
    _advancePhase();
  }

  void selectTask(String? taskId) {
    state = state.copyWith(activeTaskId: taskId);
  }

  void _tick() {
    final now = DateTime.now();
    final elapsed = now.difference(_lastTick!).inSeconds;
    _lastTick = now;

    final newRemaining = state.remainingSeconds - elapsed;
    if (newRemaining <= 0) {
      _timer?.cancel();
      _onPhaseCompleted();
    } else {
      state = state.copyWith(remainingSeconds: newRemaining);
    }
  }

  void _onPhaseCompleted() {
    if (state.isWorkPhase) {
      final newCount = state.completedPomodoros + 1;
      state = state.copyWith(completedPomodoros: newCount);
    }
    _advancePhase();
  }

  void _advancePhase() {
    final settings = ref.read(timerSettingsProvider);
    final nextPhase = _getNextPhase(settings);
    final duration = _getPhaseDuration(nextPhase, settings);

    state = TimerState(
      phase: nextPhase,
      status: TimerStateStatus.idle,
      remainingSeconds: duration,
      totalSeconds: duration,
      completedPomodoros: state.completedPomodoros,
      activeTaskId: state.activeTaskId,
    );

    final autoStart = state.isWorkPhase
        ? settings.autoStartPomodoro
        : settings.autoStartBreak;
    if (autoStart) {
      start();
    }
  }

  TimerPhase _getNextPhase(TimerSettings settings) {
    switch (state.phase) {
      case TimerPhase.work:
        final isLongBreak = state.completedPomodoros % settings.longBreakInterval == 0;
        return isLongBreak ? TimerPhase.longBreak : TimerPhase.shortBreak;
      case TimerPhase.shortBreak:
      case TimerPhase.longBreak:
        return TimerPhase.work;
    }
  }

  int _getPhaseDuration(TimerPhase phase, TimerSettings settings) {
    switch (phase) {
      case TimerPhase.work:
        return settings.workDuration * 60;
      case TimerPhase.shortBreak:
        return settings.shortBreakDuration * 60;
      case TimerPhase.longBreak:
        return settings.longBreakDuration * 60;
    }
  }
}

final timerSettingsProvider = StateNotifierProvider<TimerSettingsNotifier, TimerSettings>((ref) {
  return TimerSettingsNotifier();
});

class TimerSettingsNotifier extends StateNotifier<TimerSettings> {
  TimerSettingsNotifier() : super(const TimerSettings());

  void updateSettings(TimerSettings settings) {
    state = settings;
  }
}