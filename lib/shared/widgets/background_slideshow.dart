import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BackgroundSlideshow extends StatefulWidget {
  const BackgroundSlideshow({super.key});

  @override
  State<BackgroundSlideshow> createState() => _BackgroundSlideshowState();
}

class _BackgroundSlideshowState extends State<BackgroundSlideshow> {
  static const List<String> _images = [
    'assets/images/bg_nature.jpg',
    'assets/images/bg_stars.jpg',
    'assets/images/bg_fog.jpg',
    'assets/images/bg_sunlight.jpg',
    'assets/images/bg_mountain.jpg',
    'assets/images/bg_lake.jpg',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _nextImage());
  }

  void _nextImage() {
    if (!mounted) return;
    setState(() => _currentIndex = (_currentIndex + 1) % _images.length);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fallback color
        Container(color: AppColors.bgTint),
        // All images layered, only current visible
        for (int i = 0; i < _images.length; i++)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            opacity: i == _currentIndex ? 0.7 : 0.0,
            child: SizedBox.expand(
              child: Image(
                image: ResizeImage.resizeIfNeeded(
                  1920,
                  null,
                  AssetImage(_images[i]),
                ),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Image error $_images[i]: $error');
                  return Container(color: AppColors.bgTint);
                },
              ),
            ),
          ),
      ],
    );
  }
}