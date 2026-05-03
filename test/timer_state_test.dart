import 'package:flutter_test/flutter_test.dart';
import 'package:tico/features/timer/domain/timer_state.dart';

void main() {
  group('TimerState', () {
    test('initial state is idle work phase', () {
      const state = TimerState();
      expect(state.phase, TimerPhase.work);
      expect(state.status, TimerStateStatus.idle);
      expect(state.remainingSeconds, 25 * 60);
      expect(state.totalSeconds, 25 * 60);
      expect(state.completedPomodoros, 0);
    });

    test('progress starts at 0', () {
      const state = TimerState();
      expect(state.progress, 0.0);
    });

    test('copyWith works correctly', () {
      const state = TimerState();
      final updated = state.copyWith(
        remainingSeconds: 20 * 60,
        status: TimerStateStatus.running,
      );
      expect(updated.remainingSeconds, 20 * 60);
      expect(updated.status, TimerStateStatus.running);
      expect(updated.phase, TimerPhase.work);
    });
  });
}