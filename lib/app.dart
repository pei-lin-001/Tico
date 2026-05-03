import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/timer/presentation/timer_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../shared/widgets/navigation_bar.dart';
import '../core/constants/app_colors.dart';

typedef View = String;

class TicoApp extends ConsumerStatefulWidget {
  const TicoApp({super.key});

  @override
  ConsumerState<TicoApp> createState() => _TicoAppState();
}

class _TicoAppState extends ConsumerState<TicoApp> {
  View _currentView = 'timer';

  void _onViewChange(View view) {
    if (_currentView != view) {
      setState(() => _currentView = view);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Focus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgTint,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.bgTint,
          onSurface: AppColors.primary,
        ),
        fontFamily: 'Inter',
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1508615039623-a25605d2b022?auto=format&fit=crop&w=2000&q=80',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.7),
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: AppColors.bgTint);
                },
              ),
            ),
            // Overlay tint
            Positioned.fill(
              child: Container(color: AppColors.bgOverlay),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'POMODORO FOCUS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3.2,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: const Interval(0, 1, curve: Curves.easeOutCubic),
                      switchOutCurve: const Interval(0, 1, curve: Curves.easeInCubic),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _buildView(_currentView),
                    ),
                  ),
                  // Navigation
                  AppNavigation(
                    currentView: _currentView,
                    onViewChange: _onViewChange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView(View view) {
    return switch (view) {
      'timer' => const TimerScreen(key: ValueKey('timer')),
      'tasks' => const TasksScreen(key: ValueKey('tasks')),
      'stats' => const StatsScreen(key: ValueKey('stats')),
      'settings' => const SettingsScreen(key: ValueKey('settings')),
      _ => const TimerScreen(key: ValueKey('timer')),
    };
  }
}