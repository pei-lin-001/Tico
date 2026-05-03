enum TimerMode { work, shortBreak, longBreak }

class TaskModel {
  final String id;
  final String title;
  bool completed;
  int pomodoros;
  int totalPomodoros;

  TaskModel({
    required this.id,
    required this.title,
    this.completed = false,
    this.pomodoros = 0,
    this.totalPomodoros = 1,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
    'pomodoros': pomodoros,
    'totalPomodoros': totalPomodoros,
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'] as String,
    title: json['title'] as String,
    completed: json['completed'] as bool? ?? false,
    pomodoros: json['pomodoros'] as int? ?? 0,
    totalPomodoros: json['totalPomodoros'] as int? ?? 1,
  );

  TaskModel copyWith({
    String? id,
    String? title,
    bool? completed,
    int? pomodoros,
    int? totalPomodoros,
  }) => TaskModel(
    id: id ?? this.id,
    title: title ?? this.title,
    completed: completed ?? this.completed,
    pomodoros: pomodoros ?? this.pomodoros,
    totalPomodoros: totalPomodoros ?? this.totalPomodoros,
  );
}
