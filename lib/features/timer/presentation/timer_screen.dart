import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../data/database/tables/tables.dart';
import '../../timer/domain/timer_state.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerStateProvider);
    final timerNotifier = ref.read(timerStateProvider.notifier);
    final settings = ref.watch(timerSettingsProvider);
    final todayCount = _countCompletedWorkToday(ref);

    final totalDuration = switch (timer.mode) {
      TimerMode.work => settings.workDuration * 60,
      TimerMode.shortBreak => settings.shortBreakDuration * 60,
      TimerMode.longBreak => settings.longBreakDuration * 60,
    };
    final progress = totalDuration > 0 ? timer.timeLeft / totalDuration : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.white40,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppColors.primary10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildModeButton('专注', TimerMode.work, timer.mode, () => timerNotifier.switchMode(TimerMode.work)),
                        _buildModeButton('短休', TimerMode.shortBreak, timer.mode, () => timerNotifier.switchMode(TimerMode.shortBreak)),
                        _buildModeButton('长休', TimerMode.longBreak, timer.mode, () => timerNotifier.switchMode(TimerMode.longBreak)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.white40,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary10),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary05, blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CustomPaint(
                            painter: _RingPainter(progress: progress, color: AppColors.primary, bgColor: AppColors.primary10),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _TimerDigitDisplay(timeLeft: timer.timeLeft),
                            const SizedBox(height: 8),
                            Text(
                              timer.mode == TimerMode.work ? '保持专注' : '放松一下',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: AppColors.primary.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton(Icons.refresh, () => timerNotifier.reset()),
                      const SizedBox(width: 16),
                      _buildMainButton(timer.isActive, () {
                        if (timer.isActive) {
                          timerNotifier.pause();
                        } else {
                          timerNotifier.start();
                        }
                      }),
                      const SizedBox(width: 16),
                      _buildIconButton(Icons.skip_next, () => timerNotifier.reset()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (todayCount > 0)
                    Text(
                      '今天已完成 $todayCount 个循环',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _countCompletedWorkToday(WidgetRef ref) {
    final asyncVal = ref.read(pomodoroSessionsProvider);
    return asyncVal.maybeWhen(
      data: (sessions) {
        final today = DateTime.now();
        return sessions.where((s) =>
          s.type == PomodoroType.work &&
          s.status == PomodoroStatus.completed &&
          s.startTime.year == today.year &&
          s.startTime.month == today.month &&
          s.startTime.day == today.day,
        ).length;
      },
      orElse: () => 0,
    );
  }

  Widget _buildModeButton(String label, TimerMode mode, TimerMode currentMode, VoidCallback onTap) {
    final isActive = currentMode == mode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          boxShadow: isActive
              ? [BoxShadow(color: AppColors.primary20, blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.white : AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary20),
          color: AppColors.white40,
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
    );
  }

  Widget _buildMainButton(bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(color: isActive ? AppColors.primary10 : AppColors.primary20, blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? Icons.pause : Icons.play_arrow, size: 24, color: isActive ? AppColors.primary : AppColors.white),
            const SizedBox(width: 8),
            Text(
              isActive ? '暂停计时' : '开始计时',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isActive ? AppColors.primary : AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;
  _RingPainter({required this.progress, required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    final strokeWidth = 8.0;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final fgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2,
        -2 * 3.14159 * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress;
}

class _TimerDigitDisplay extends StatelessWidget {
  final int timeLeft;
  const _TimerDigitDisplay({required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    final mins = (timeLeft / 60).floor();
    final secs = timeLeft % 60;
    final d = [mins ~/ 10, mins % 10, -1, secs ~/ 10, secs % 10];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: d.map((v) {
        if (v < 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(':', style: _digitStyle),
          );
        }
        return _DigitSlot(digit: v);
      }).toList(),
    );
  }

  static const _digitStyle = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: -1,
    height: 1,
  );
}

class _DigitSlot extends StatelessWidget {
  final int digit;
  const _DigitSlot({required this.digit});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        '$digit',
        key: ValueKey(digit),
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
          fontFeatures: [FontFeature.tabularFigures()],
          height: 1,
        ),
      ),
    );
  }
}