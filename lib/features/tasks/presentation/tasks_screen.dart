import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<TaskModel> _tasks = [];
  bool _isAdding = false;
  final _titleController = TextEditingController();
  int _estPomodoros = 1;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_titleController.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        totalPomodoros: _estPomodoros,
      ));
      _titleController.clear();
      _estPomodoros = 1;
      _isAdding = false;
    });
  }

  void _toggleTask(TaskModel task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  void _deleteTask(TaskModel task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '任务清单',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  fontFamily: 'Cormorant Garamond',
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isAdding = !_isAdding),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E6D1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '添加任务',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isAdding) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white60,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.primary10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '你在忙什么？',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.primary40,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '预估番茄钟',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white40,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary10),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (v) => _estPomodoros = int.tryParse(v) ?? 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isAdding = false),
                        child: Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _addTask,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('保存', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          ..._tasks.map((task) => _buildTaskCard(task)),
          if (_tasks.isEmpty && !_isAdding)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary05,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary10),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 24,
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '还没有任务？点击右上角添加。',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white40,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleTask(task),
            child: Icon(
              task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 24,
              color: task.completed
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '已专注 ${task.pomodoros} / ${task.totalPomodoros} 番茄',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.6,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _deleteTask(task),
            child: Icon(
              Icons.delete_outline,
              size: 20,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}