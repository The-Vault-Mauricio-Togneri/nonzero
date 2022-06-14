import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nonzero/models/task.dart';

class Repository {
  static Future<List<Task>> tasks() async {
    final List<Task> tasks = [];
    final result = await collection().get();

    for (final document in result.docs) {
      tasks.add(Task.fromDocument(document));
    }

    return tasks;
  }

  static Future<Task> add(Task task) async {
    final document = await collection().add(task.document);

    return Task(
      id: document.id,
      name: task.name,
      priority: task.priority,
      completed: task.completed,
    );
  }

  static Future update(Task task) => collection().doc(task.id).set(task.document);

  static Future delete(Task task) => collection().doc(task.id).delete();

  static CollectionReference<Map<String, dynamic>> collection() => FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid);
}
