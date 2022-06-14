import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:nonzero/dialogs/confirmation_dialog.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/screens/edit_screen.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/repository.dart';
import 'package:nonzero/services/routes.dart';
import 'package:nonzero/storage/last_restart_storage.dart';
import 'package:nonzero/widgets/label.dart';

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
          ),
          body: Content(state),
          floatingActionButton: FloatingActionButton(
            onPressed: state.onAddTask,
            child: const Icon(Icons.add),
          ),
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
    return StateProvider<MainState>(
      state: state,
      builder: (context, state) => state.tasks.isEmpty ? const Waiting() : TaskList(state),
    );
  }
}

class Waiting extends StatelessWidget {
  const Waiting();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class TaskList extends StatelessWidget {
  final MainState state;

  const TaskList(this.state);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: state.tasks.length,
      itemBuilder: (context, index) => TaskEntry(
        state: state,
        task: state.tasks[index],
      ),
      separatorBuilder: (context, index) => const HorizontalDivider(
        height: 0.1,
        color: Palette.black,
      ),
    );
  }
}

class TaskEntry extends StatelessWidget {
  final MainState state;
  final Task task;

  const TaskEntry({
    required this.state,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: const DismissibleBackground(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        icon: Icons.check,
      ),
      secondaryBackground: const DismissibleBackground(
        color: Colors.red,
        alignment: Alignment.centerRight,
        icon: Icons.delete,
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          state.onTaskDeleted(task);
        } else {
          state.onTaskSelected(task);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return ConfirmationDialog.show(
            context: context,
            message: 'Delete task?',
          );
        } else {
          return true;
        }
      },
      child: Container(
        width: double.infinity,
        color: !task.completed ? task.priority.color : Palette.lightGrey,
        child: Material(
          color: Palette.transparent,
          child: InkWell(
            onTap: () => state.onTaskSelected(task),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 17, 12, 17),
              child: Label(
                text: task.name,
                size: 12,
                color: task.completed ? Palette.darkGrey : Palette.black,
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissibleBackground extends StatelessWidget {
  final Color color;
  final Alignment alignment;
  final IconData icon;

  const DismissibleBackground({
    required this.color,
    required this.alignment,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MainState extends BaseState {
  final List<Task> tasks = [];

  MainState() {
    load();
  }

  Future load() async {
    tasks.clear();
    notify();

    tasks.addAll(await Repository.tasks());

    final DateTime lastRestart = await LastRestartStorage.load();

    if (DateTime.now().day != lastRestart.day) {
      LastRestartStorage.save();

      for (final Task task in tasks) {
        task.completed = false;
        Repository.update(task);
      }
    }

    tasks.sort((a, b) => a.compareTo(b));
    notify();
  }

  void onTaskSelected(Task task) {
    task.toggle();
    Repository.update(task);
    tasks.sort((a, b) => a.compareTo(b));
    notify();
  }

  void onTaskDeleted(Task task) {
    tasks.remove(task);
    Repository.delete(task);
    tasks.sort((a, b) => a.compareTo(b));
    notify();
  }

  Future onAddTask() async {
    await Routes.push(EditScreen.instance());
    load();
  }
}
