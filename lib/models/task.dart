import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:nonzero/types/priority.dart';

part 'task.g.dart';

@JsonSerializable()
class Task implements Comparable<Task> {
  final String name;
  final Priority priority;
  bool completed;

  Task({
    required this.name,
    required this.priority,
    this.completed = false,
  });

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

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  static List<Task> fromList(String json) {
    final List<dynamic> list = jsonDecode(json);

    final List<Task> result = [];

    for (final dynamic entry in list) {
      result.add(Task.fromJson(entry));
    }

    result.sort((a, b) => a.compareTo(b));

    return result;
  }

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
