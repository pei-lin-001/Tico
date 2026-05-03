import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tico/data/database/database.dart';
import 'package:tico/domain/repositories/repositories.dart';
import 'package:tico/data/repositories/task_repository_impl.dart';
import 'package:tico/data/repositories/pomodoro_repository_impl.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepositoryImpl(db);
});

final pomodoroRepositoryProvider = Provider<PomodoroRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PomodoroRepositoryImpl(db);
});