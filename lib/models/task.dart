import 'package:nonzero/types/priority.dart';

class Task implements Comparable<Task> {
  final String id;
  final String name;
  final Priority priority;
  bool completed;

  Task({
    required this.id,
    required this.name,
    required this.priority,
    required this.completed,
  });

  Map<String, dynamic> get document => <String, dynamic>{
        'name': name,
        'priority': priority.name,
        'completed': completed,
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
