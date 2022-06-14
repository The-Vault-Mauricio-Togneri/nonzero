import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:nonzero/dialogs/confirmation_dialog.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/repository.dart';
import 'package:nonzero/services/url_launcher.dart';
import 'package:nonzero/storage/last_restart_storage.dart';
import 'package:nonzero/storage/tasks_storage.dart';
import 'package:nonzero/types/priority.dart';
import 'package:nonzero/widgets/label.dart';
import 'package:nonzero/widgets/run_once.dart';

class MainScreen extends StatelessWidget {
  final MainState state = MainState();

  static FadeRoute instance() => FadeRoute(MainScreen());

  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: StateProvider<MainState>(
        state: state,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Label(
              text: 'Non Zero',
              color: Palette.white,
              size: 16,
            ),
            actions: [
              IconButton(
                onPressed: () => state.onDownload(context),
                icon: const Icon(Icons.download),
              ),
              IconButton(
                onPressed: () => state.onReset(context),
                icon: const Icon(Icons.restart_alt_rounded),
              ),
              IconButton(
                onPressed: state.onOpenSheet,
                icon: const Icon(Icons.open_in_new),
              ),
            ],
          ),
          body: Content(state),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final MainState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return RunOnce(
      function: () => state.load(context),
      child: StateProvider<MainState>(
        state: state,
        builder: (context, state) => state.tasks.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) => TaskLine(state, state.tasks[index]),
                separatorBuilder: (context, index) => const HorizontalDivider(
                  height: 0.1,
                  color: Palette.black,
                ),
              ),
      ),
    );
  }
}

class TaskLine extends StatelessWidget {
  final MainState state;
  final Task task;

  const TaskLine(this.state, this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: !task.completed ? task.priority.color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: () => state.onTaskSelected(task),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Label(
              text: task.name,
              color: task.completed ? Palette.darkGrey : Palette.black,
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}

class MainState extends BaseState {
  final List<Task> tasks = [];

  Future load(BuildContext context) async {
    tasks.addAll(await Repository.tasks());
    notify();

    final DateTime lastRestart = await LastRestartStorage.load();

    if (DateTime.now().day > lastRestart.day) {
      ConfirmationDialog.show(
        context: context,
        message: 'Restart progress?',
        callback: () async {
          await LastRestartStorage.save();
          _downloadData(context);
        },
      );
    }

    /*final user = <String, dynamic>{
      'name': 'Item 1',
      'priority': 'medium',
    };

    await FirebaseFirestore.instance.collection('mauricio.togneri@gmail.com').add(user);*/

    final result = await FirebaseFirestore.instance.collection('mauricio.togneri@gmail.com').get();

    for (final doc in result.docs) {
      print('${doc.id} => ${doc.data()}');
    }
  }

  void onTaskSelected(Task task) {
    task.toggle();
    tasks.sort((a, b) => a.compareTo(b));
    notify();

    TasksStorage.save(tasks);
  }

  void onDownload(BuildContext context) => ConfirmationDialog.show(
        context: context,
        message: 'Download data?',
        callback: () => _downloadData(context),
      );

  void onReset(BuildContext context) => ConfirmationDialog.show(
        context: context,
        message: 'Reset progress?',
        callback: _applyReset,
      );

  void _applyReset() {
    for (final Task task in tasks) {
      task.completed = false;
    }
    tasks.sort((a, b) => a.compareTo(b));
    notify();
    TasksStorage.save(tasks);
  }

  void _downloadData(BuildContext context) {
    tasks.clear();
    notify();
    Repository.reset();
    load(context);
  }

  void onOpenSheet() => UrlLauncher.open('https://docs.google.com/spreadsheets/d/18fO4L8m7dVfzA74YMOHbjYOFCxuvZGrPhfhCMS6DUFE/edit');
}
