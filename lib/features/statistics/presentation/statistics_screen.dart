import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class _StatsEntry {
  final String date;
  final int count;
  final int minutes;

  const _StatsEntry(this.date, this.count, this.minutes);
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = const [
      _StatsEntry('周一', 4, 100),
      _StatsEntry('周二', 6, 150),
      _StatsEntry('周三', 2, 50),
      _StatsEntry('周四', 8, 200),
      _StatsEntry('周五', 5, 125),
      _StatsEntry('周六', 3, 75),
      _StatsEntry('今日', 0, 0),
    ];

    final totalMinutes = stats.fold(0, (a, s) => a + s.minutes);
    final totalSessions = stats.fold(0, (a, s) => a + s.count);
    final maxMinutes = stats.map((s) => s.minutes).reduce((a, b) => a > b ? a : b);

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
          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '专注时长',
                  '${(totalMinutes / 60).floor()}',
                  '时 ${totalMinutes % 60} 分',
                  Icons.access_time,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '完成番茄',
                  '$totalSessions',
                  '个',
                  Icons.track_changes,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white40,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.primary10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '本周专注趋势',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: stats.map((entry) {
                      final isToday = entry.date == '今日';
                      final height = maxMinutes > 0
                          ? (entry.minutes / maxMinutes * 120).clamp(16.0, 120.0)
                          : 16.0;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: height,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.primary
                                      : AppColors.primary20,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.date,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                ),
                              ),
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
          // History
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white40,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.primary10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '历史记录',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 12),
                ...stats.reversed.map((entry) => Container(
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
                        decoration: BoxDecoration(
                          color: AppColors.primary10,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.center_focus_strong,
                          size: 16,
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.date,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '${entry.count} 个番茄钟',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${entry.minutes}m',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white40,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary.withValues(alpha: 0.6)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}