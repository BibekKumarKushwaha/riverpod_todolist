// lib/models/task.dart
class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isFavorite;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isFavorite = false,
  });

  Task copyWith({String? id, String? title, bool? isCompleted, bool? isFavorite}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
