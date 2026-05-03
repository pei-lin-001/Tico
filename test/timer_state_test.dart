import 'package:flutter_test/flutter_test.dart';
import 'package:tico/domain/models/task_model.dart';

void main() {
  group('TaskModel', () {
    test('creates with defaults', () {
      final task = TaskModel(id: '1', title: 'Test');
      expect(task.completed, false);
      expect(task.pomodoros, 0);
      expect(task.totalPomodoros, 1);
    });

    test('copyWith works', () {
      final task = TaskModel(id: '1', title: 'Test');
      final updated = task.copyWith(title: 'Updated', pomodoros: 2);
      expect(updated.title, 'Updated');
      expect(updated.pomodoros, 2);
      expect(updated.id, '1');
    });

    test('json roundtrip', () {
      final task = TaskModel(
        id: '1',
        title: 'Test',
        completed: true,
        pomodoros: 3,
        totalPomodoros: 5,
      );
      final json = task.toJson();
      final restored = TaskModel.fromJson(json);
      expect(restored.title, 'Test');
      expect(restored.completed, true);
      expect(restored.pomodoros, 3);
    });
  });
}