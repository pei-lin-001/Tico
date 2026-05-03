import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/timer/presentation/timer_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../shared/widgets/navigation_bar.dart';
import '../shared/widgets/background_slideshow.dart';
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

  Widget _buildView(View view) {
    return switch (view) {
      'timer' => const TimerScreen(key: ValueKey('timer')),
      'tasks' => const TasksScreen(key: ValueKey('tasks')),
      'stats' => const StatsScreen(key: ValueKey('stats')),
      'settings' => const SettingsScreen(key: ValueKey('settings')),
      _ => const TimerScreen(key: ValueKey('timer')),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tico',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgTint,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.bgTint,
          onSurface: AppColors.primary,
        ),
        fontFamily: 'Inter',
        scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: WidgetStatePropertyAll(false),
          trackVisibility: WidgetStatePropertyAll(false),
          thickness: WidgetStatePropertyAll(0),
        ),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Background Slideshow
            Positioned.fill(
              child: const BackgroundSlideshow(),
            ),
            // Semi-transparent overlay tint
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
                          'TICO',
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
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 672),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: const Interval(0, 1, curve: Curves.easeOutCubic),
                        switchOutCurve: const Interval(0, 1, curve: Curves.easeInCubic),
                        transitionBuilder: (child, animation) {
                          final isEntering = (child.key as ValueKey<String>).value == _currentView;
                          if (isEntering) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
                                child: child,
                              ),
                            );
                          } else {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 1.0, end: 1.02)
                                    .animate(ReverseAnimation(animation)),
                                child: child,
                              ),
                            );
                          }
                        },
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        child: _buildView(_currentView),
                      ),
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
}