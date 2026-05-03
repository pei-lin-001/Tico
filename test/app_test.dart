import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tico/app.dart';

void main() {
  testWidgets('app builds without error', (tester) async {
    await tester.pumpWidget(const TicoApp());
    expect(find.text('POMODORO FOCUS'), findsOneWidget);
  });

  testWidgets('timer screen shows controls', (tester) async {
    await tester.pumpWidget(const TicoApp());
    expect(find.text('开始计时'), findsOneWidget);
    expect(find.text('专注'), findsOneWidget);
    expect(find.text('短休'), findsOneWidget);
    expect(find.text('长休'), findsOneWidget);
  });
}