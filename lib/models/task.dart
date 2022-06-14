import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nonzero/types/priority.dart';

class Task implements Comparable<Task> {
  final String id;
  final String name;
  final Priority priority;
  bool completed;

  static const String FIELD_ID = 'id';
  static const String FIELD_NAME = 'name';
  static const String FIELD_PRIORITY = 'priority';
  static const String FIELD_COMPLETED = 'completed';

  Task({
    required this.id,
    required this.name,
    required this.priority,
    required this.completed,
  });

  factory Task.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final map = document.data();

    return Task(
      id: document.id,
      name: map[FIELD_NAME],
      priority: Priority.parse(map[FIELD_PRIORITY]),
      completed: map[FIELD_COMPLETED] as bool,
    );
  }

  Map<String, dynamic> get document => <String, dynamic>{
        FIELD_NAME: name,
        FIELD_PRIORITY: priority.name,
        FIELD_COMPLETED: completed,
      };

  void toggle() => completed = !completed;

  @override
  int compareTo(Task other) {
    if (completed && !other.completed) {
      return 1;
    } else if (!completed && other.completed) {
      return -1;
    } else if (priority.index == other.priority.index) {
      return name.compareTo(other.name);
    } else {
      return priority.index - other.priority.index;
    }
  }
}
