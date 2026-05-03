class TimerSettings {
  final int workDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int longBreakInterval;
  final bool autoStartBreak;
  final bool autoStartPomodoro;

  const TimerSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakInterval = 4,
    this.autoStartBreak = false,
    this.autoStartPomodoro = false,
  });

  TimerSettings copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? longBreakInterval,
    bool? autoStartBreak,
    bool? autoStartPomodoro,
  }) {
    return TimerSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      autoStartBreak: autoStartBreak ?? this.autoStartBreak,
      autoStartPomodoro: autoStartPomodoro ?? this.autoStartPomodoro,
    );
  }
}