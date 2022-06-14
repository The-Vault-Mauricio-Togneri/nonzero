import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/types/priority.dart';

class Repository {
  static const String USER_ID = 'mauricio.togneri@gmail.com';

  static Future<List<Task>> tasks() async {
    final List<Task> tasks = [];
    final result = await FirebaseFirestore.instance.collection(USER_ID).get();

    for (final doc in result.docs) {
      final map = doc.data();

      tasks.add(Task(
        id: doc.id,
        name: map['name'],
        priority: Priority.parse(map['priority']),
        completed: map['completed'] as bool,
      ));
    }

    return tasks;
  }

  static Future<Task> add(Task task) async {
    final document = await FirebaseFirestore.instance.collection(USER_ID).add(task.document);

    return Task(
      id: document.id,
      name: task.name,
      priority: task.priority,
      completed: task.completed,
    );
  }

  static Future update(Task task) => FirebaseFirestore.instance.collection(USER_ID).doc(task.id).set(task.document);

  static Future delete(Task task) => FirebaseFirestore.instance.collection(USER_ID).doc(task.id).delete();
}
