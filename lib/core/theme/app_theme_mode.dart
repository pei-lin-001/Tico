import 'package:flutter/material.dart';
import 'app_colors.dart';

enum AppThemeMode { system, light, dark }

enum AppAccentColor { tomato, green, blue, orange, purple, teal }

extension AppAccentColorX on AppAccentColor {
  Color get color => switch (this) {
        AppAccentColor.tomato => AppColors.tomato,
        AppAccentColor.green => AppColors.green,
        AppAccentColor.blue => AppColors.blue,
        AppAccentColor.orange => AppColors.orange,
        AppAccentColor.purple => AppColors.purple,
        AppAccentColor.teal => AppColors.teal,
      };

  String get label => switch (this) {
        AppAccentColor.tomato => '番茄红',
        AppAccentColor.green => '清新绿',
        AppAccentColor.blue => '天空蓝',
        AppAccentColor.orange => '活力橙',
        AppAccentColor.purple => '优雅紫',
        AppAccentColor.teal => '薄荷青',
      };
}