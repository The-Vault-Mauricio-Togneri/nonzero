import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/storage/tasks_storage.dart';

class Repository {
  static Future<List<Task>> tasks() async {
    final List<Task> tasks = await _fromDisk();

    if (tasks.isNotEmpty) {
      return tasks;
    } else {
      tasks.addAll(await _fromNetwork());
      await TasksStorage.save(tasks);

      return tasks;
    }
  }

  static Future<List<Task>> _fromDisk() => TasksStorage.load();

  static Future<List<Task>> _fromNetwork() async {
    final Uri url = Uri.parse('https://script.google.com/macros/s/AKfycbyLgwV-hjwYwmyHoP0c2PIADzh-r0uvN5we6pea7bOYJsGkXPQDzPoJuRRdrq6i_u3yag/exec');
    final Response response = await http.get(url);

    return Task.fromList(response.body);
  }

  static Future reset() => TasksStorage.clear();
}
