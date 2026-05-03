import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/pomodoro_session_model.dart';
import '../../../data/database/tables/tables.dart';
import '../../../shared/widgets/glass_container.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(pomodoroSessionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            '统计概览',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
              fontFamily: 'Cormorant Garamond',
            ),
          ),
          const SizedBox(height: 24),
          sessionsAsync.when(
            data: (sessions) {
              final now = DateTime.now();
              final todayStart = DateTime(now.year, now.month, now.day);
              final weekStart = todayStart.subtract(Duration(days: todayStart.weekday - 1));

              final workSessions = sessions.where((s) =>
                s.type == PomodoroType.work && s.status == PomodoroStatus.completed
              ).toList();

              final totalMinutes = workSessions.fold<int>(0, (sum, s) => sum + ((s.actualDuration ?? s.plannedDuration * 60) ~/ 60));
              final totalSessions = workSessions.length;

              final weekDays = _buildWeekData(workSessions, weekStart, now);

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GlassContainer(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(16),
                          color: const Color(0x33FFFFFF),
                          child: _buildStatCardContent('专注时长', '${totalMinutes ~/ 60}', '时 ${totalMinutes % 60} 分', Icons.access_time),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassContainer(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(16),
                          color: const Color(0x33FFFFFF),
                          child: _buildStatCardContent('完成番茄', '$totalSessions', '个', Icons.track_changes),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GlassContainer(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(20),
                    color: const Color(0x33FFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('本周专注趋势', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.primary.withValues(alpha: 0.6))),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 160,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: weekDays.map((entry) {
                              final isToday = entry['isToday'] as bool;
                              final minutes = entry['minutes'] as int;
                              final maxMin = entry['maxMinutes'] as int;
                              final targetHeight = maxMin > 0
                                  ? (minutes / maxMin * 120).clamp(16.0, 120.0)
                                  : 16.0;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _BarColumn(
                                        targetHeight: targetHeight,
                                        color: isToday ? AppColors.primary : AppColors.primary20,
                                        delay: (entry['index'] as int) * 60,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(entry['label'] as String, style: TextStyle(fontSize: 11, color: AppColors.primary.withValues(alpha: 0.5))),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassContainer(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(20),
                    color: const Color(0x33FFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('历史记录', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.primary.withValues(alpha: 0.6))),
                        const SizedBox(height: 12),
                        if (workSessions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text('暂无专注记录', style: TextStyle(fontSize: 14, color: AppColors.primary.withValues(alpha: 0.4))),
                            ),
                          )
                        else
                          ...workSessions.reversed.take(20).map((s) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white40,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary05),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.primary10, shape: BoxShape.circle),
                                  child: Icon(Icons.center_focus_strong, size: 16, color: AppColors.primary.withValues(alpha: 0.6)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(s.startTime),
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
                                      ),
                                      Text(
                                        _typeLabel(s.type),
                                        style: TextStyle(fontSize: 12, color: AppColors.primary.withValues(alpha: 0.6)),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${(s.actualDuration ?? s.plannedDuration * 60) ~/ 60}m',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
                                ),
                              ],
                            ),
                          )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator(color: AppColors.primary))),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Text('加载失败: $e', style: const TextStyle(color: AppColors.primary)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _buildWeekData(List<PomodoroSessionModel> workSessions, DateTime weekStart, DateTime now) {
    final labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final maxMinutes = <int, int>{};
    final days = <Map<String, dynamic>>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayMinutes = workSessions.where((s) =>
        s.startTime.year == day.year && s.startTime.month == day.month && s.startTime.day == day.day
      ).fold<int>(0, (sum, s) {
        final dur = s.actualDuration ?? s.plannedDuration * 60;
        return sum + (dur ~/ 60);
      });
      maxMinutes[i] = dayMinutes;
      final isToday = day.year == now.year && day.month == now.month && day.day == now.day;
      days.add({
        'label': isToday ? '今日' : labels[i],
        'minutes': dayMinutes,
        'isToday': isToday,
        'index': i,
      });
    }

    final maxVal = maxMinutes.values.fold(0, (a, b) => a > b ? a : b);
    return days.map((d) => {...d, 'maxMinutes': maxVal}).toList();
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}月${dt.day}日 ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _typeLabel(PomodoroType type) {
    return switch (type) {
      PomodoroType.work => '专注',
      PomodoroType.shortBreak => '短休',
      PomodoroType.longBreak => '长休',
    };
  }

  Widget _buildStatCardContent(String label, String value, String unit, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary.withValues(alpha: 0.6)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.6, color: AppColors.primary.withValues(alpha: 0.6))),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: AppColors.primary)),
            const SizedBox(width: 4),
            Text(unit, style: TextStyle(fontSize: 14, color: AppColors.primary.withValues(alpha: 0.7))),
          ],
        ),
      ],
    );
  }
}

class _BarColumn extends StatefulWidget {
  final double targetHeight;
  final Color color;
  final int delay;

  const _BarColumn({required this.targetHeight, required this.color, required this.delay});

  @override
  State<_BarColumn> createState() => _BarColumnState();
}

class _BarColumnState extends State<_BarColumn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heightAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(_BarColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetHeight != widget.targetHeight) {
      _controller.reset();
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: widget.targetHeight * _heightAnimation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }
}