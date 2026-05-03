import 'package:shared_preferences/shared_preferences.dart';
import 'package:tico/domain/models/timer_settings.dart';

class SettingsRepository {
  static const _keyWorkDuration = 'work_duration';
  static const _keyShortBreakDuration = 'short_break_duration';
  static const _keyLongBreakDuration = 'long_break_duration';
  static const _keyLongBreakInterval = 'long_break_interval';
  static const _keyAutoStartBreak = 'auto_start_break';
  static const _keyAutoStartPomodoro = 'auto_start_pomodoro';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  TimerSettings getTimerSettings() {
    return TimerSettings(
      workDuration: _prefs.getInt(_keyWorkDuration) ?? 25,
      shortBreakDuration: _prefs.getInt(_keyShortBreakDuration) ?? 5,
      longBreakDuration: _prefs.getInt(_keyLongBreakDuration) ?? 15,
      longBreakInterval: _prefs.getInt(_keyLongBreakInterval) ?? 4,
      autoStartBreak: _prefs.getBool(_keyAutoStartBreak) ?? false,
      autoStartPomodoro: _prefs.getBool(_keyAutoStartPomodoro) ?? false,
    );
  }

  Future<void> saveTimerSettings(TimerSettings settings) async {
    await _prefs.setInt(_keyWorkDuration, settings.workDuration);
    await _prefs.setInt(_keyShortBreakDuration, settings.shortBreakDuration);
    await _prefs.setInt(_keyLongBreakDuration, settings.longBreakDuration);
    await _prefs.setInt(_keyLongBreakInterval, settings.longBreakInterval);
    await _prefs.setBool(_keyAutoStartBreak, settings.autoStartBreak);
    await _prefs.setBool(_keyAutoStartPomodoro, settings.autoStartPomodoro);
  }
}