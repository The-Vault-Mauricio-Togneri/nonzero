import 'dart:convert';
import 'package:nonzero/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksStorage {
  static const FIELD = 'tasks';

  static Future save(List<Task> tasks) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(FIELD, jsonEncode(tasks));
  }

  static Future<List<Task>> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String data = preferences.getString(FIELD) ?? '[]';

    return Task.fromList(data);
  }

  static Future clear() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(FIELD);
  }
}
