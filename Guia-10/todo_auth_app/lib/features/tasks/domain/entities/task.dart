class Task {
  final int id;
  final String title;
  final bool completed;
  final int userId;

  const Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      userId: json['userId'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'completed': completed,
        'userId': userId,
      };

  Task copyWith({String? title, bool? completed}) {
    return Task(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      userId: userId,
    );
  }
}