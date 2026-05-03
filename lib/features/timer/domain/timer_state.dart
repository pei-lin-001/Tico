enum TimerPhase { work, shortBreak, longBreak }

enum TimerStateStatus { idle, running, paused, completed }

class TimerState {
  final TimerPhase phase;
  final TimerStateStatus status;
  final int remainingSeconds;
  final int totalSeconds;
  final int completedPomodoros;
  final String? activeTaskId;

  const TimerState({
    this.phase = TimerPhase.work,
    this.status = TimerStateStatus.idle,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.completedPomodoros = 0,
    this.activeTaskId,
  });

  double get progress =>
      totalSeconds > 0 ? 1 - (remainingSeconds / totalSeconds) : 0.0;
  bool get isWorkPhase => phase == TimerPhase.work;
  bool get isRunning => status == TimerStateStatus.running;
  bool get isPaused => status == TimerStateStatus.paused;
  bool get isIdle => status == TimerStateStatus.idle;

  TimerState copyWith({
    TimerPhase? phase,
    TimerStateStatus? status,
    int? remainingSeconds,
    int? totalSeconds,
    int? completedPomodoros,
    String? activeTaskId,
    bool clearTaskId = false,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      activeTaskId: clearTaskId ? null : (activeTaskId ?? this.activeTaskId),
    );
  }
}