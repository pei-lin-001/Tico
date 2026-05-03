import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

typedef View = String;

class AppNavigation extends StatelessWidget {
  final View currentView;
  final void Function(View) onViewChange;

  const AppNavigation({
    super.key,
    required this.currentView,
    required this.onViewChange,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      (id: 'timer', icon: Icons.timer_outlined, label: '计时'),
      (id: 'tasks', icon: Icons.checklist_outlined, label: '任务'),
      (id: 'stats', icon: Icons.bar_chart_outlined, label: '排行'),
      (id: 'settings', icon: Icons.settings_outlined, label: '设置'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabs.map((tab) {
          final isActive = currentView == tab.id;
          return GestureDetector(
            onTap: () => onViewChange(tab.id),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )
                else
                  const SizedBox(height: 10),
                Icon(
                  tab.icon,
                  size: 22,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 2),
                Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}