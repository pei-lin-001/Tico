import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

enum TimerMode { work, shortBreak, longBreak }

class _TimerScreenState extends ConsumerState<TimerScreen> {
  TimerMode _mode = TimerMode.work;
  int _timeLeft = 25 * 60;
  bool _isActive = false;
  int _pomodoroCount = 0;
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;
  int _longBreakInterval = 4;

  @override
  void initState() {
    super.initState();
    _timeLeft = _workDuration * 60;
  }

  int _getDurationByMode(TimerMode m) {
    return switch (m) {
      TimerMode.work => _workDuration * 60,
      TimerMode.shortBreak => _shortBreakDuration * 60,
      TimerMode.longBreak => _longBreakDuration * 60,
    };
  }

  void _switchMode(TimerMode newMode) {
    setState(() {
      _mode = newMode;
      _timeLeft = _getDurationByMode(newMode);
      _isActive = false;
    });
  }

  void _toggleTimer() {
    if (_isActive) {
      setState(() => _isActive = false);
    } else {
      setState(() => _isActive = true);
      _startTicking();
    }
  }

  void _startTicking() async {
    while (_isActive && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isActive) break;
      setState(() {
        _timeLeft -= 1;
        if (_timeLeft <= 0) {
          _handleTimerComplete();
        }
      });
    }
  }

  void _handleTimerComplete() {
    _isActive = false;
    if (_mode == TimerMode.work) {
      _pomodoroCount++;
      if (_pomodoroCount % _longBreakInterval == 0) {
        _switchMode(TimerMode.longBreak);
      } else {
        _switchMode(TimerMode.shortBreak);
      }
    } else {
      _switchMode(TimerMode.work);
    }
  }

  void _resetTimer() {
    setState(() {
      _isActive = false;
      _timeLeft = _getDurationByMode(_mode);
    });
  }

  void _skipTimer() {
    _handleTimerComplete();
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = _getDurationByMode(_mode);
    final progress = _timeLeft / totalDuration;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          // Mode selector
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
                _buildModeButton('专注', TimerMode.work),
                _buildModeButton('短休', TimerMode.shortBreak),
                _buildModeButton('长休', TimerMode.longBreak),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Circle Timer
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.white40,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary05,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // SVG-like ring using CustomPaint
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CustomPaint(
                    painter: _RingPainter(
                      progress: progress,
                      color: AppColors.primary,
                      bgColor: AppColors.primary10,
                    ),
                  ),
                ),
                // Time display
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _formatTime(_timeLeft),
                        key: ValueKey(_timeLeft),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          fontFeatures: [FontFeature.tabularFigures()],
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _mode == TimerMode.work ? '保持专注' : '放松一下',
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
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(Icons.refresh, _resetTimer),
              const SizedBox(width: 16),
              _buildMainButton(),
              const SizedBox(width: 16),
              _buildIconButton(Icons.skip_next, _skipTimer),
            ],
          ),
          const SizedBox(height: 24),
          if (_pomodoroCount > 0)
            Text(
              '今天已完成 $_pomodoroCount 个循环',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, TimerMode mode) {
    final isActive = _mode == mode;
    return GestureDetector(
      onTap: () => _switchMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary20,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
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

  Widget _buildMainButton() {
    return GestureDetector(
      onTap: _toggleTimer,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: _isActive ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: _isActive ? AppColors.primary10 : AppColors.primary20,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isActive ? Icons.pause : Icons.play_arrow,
              size: 24,
              color: _isActive ? AppColors.primary : AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              _isActive ? '暂停计时' : '开始计时',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isActive ? AppColors.primary : AppColors.white,
              ),
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

  _RingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    final strokeWidth = 8.0;

    // Background ring
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
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
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}