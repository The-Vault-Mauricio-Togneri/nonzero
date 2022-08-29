import 'dart:async';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:nonzero/dialogs/confirmation_dialog.dart';
import 'package:nonzero/dialogs/options_dialog.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/services/localizations.dart';
import 'package:nonzero/services/navigation.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/repository.dart';
import 'package:nonzero/widgets/label.dart';
import 'package:nonzero/widgets/screen_container.dart';

class MainScreen extends StatelessWidget {
  final MainState state;

  const MainScreen._(this.state);

  factory MainScreen.instance() => MainScreen._(MainState());

  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: ScreenContainer(
        child: StateProvider<MainState>(
          state: state,
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Label(
                text: Localized.get.appName,
                color: Palette.white,
                size: 16,
              ),
              actions: [
                IconButton(
                  onPressed: state.markAllAsNotCompleted,
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
              ],
            ),
            body: Content(state),
            floatingActionButton: FloatingActionButton(
              onPressed: state.onAddTask,
              child: const Icon(Icons.add),
            ),
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
      builder: (context, state) => state.hasTasks ? (state.tasks.isEmpty ? const NoTasks() : TaskList(state)) : const Waiting(),
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

class NoTasks extends StatelessWidget {
  const NoTasks();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Label(
        text: Localized.get.listEmpty,
        color: Palette.black,
      ),
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
      background: DismissibleBackground(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        icon: task.completed ? Icons.undo : Icons.check,
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
            message: Localized.get.confirmationDeleteTask,
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
            onLongPress: () => state.onOptionsSelected(task),
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
  List<Task>? _tasks;
  StreamSubscription? subscription;

  List<Task> get tasks => _tasks!;

  bool get hasTasks => _tasks != null;

  @override
  void onLoad() => subscription ??= Repository.listen(onTasksLoaded);

  @override
  void onDestroy() {
    subscription?.cancel();
    subscription = null;
  }

  Future onTasksLoaded(List<Task> tasks) async {
    _tasks = tasks;
    _tasks!.sort((a, b) => a.compareTo(b));
    notify();
  }

  void markAllAsNotCompleted() {
    onDestroy();

    for (final Task task in _tasks!) {
      task.completed = false;
      Repository.update(task);
    }

    onLoad();
  }

  void onTaskSelected(Task task) {
    task.toggle();
    Repository.update(task);
    _tasks!.sort((a, b) => a.compareTo(b));
    notify();
  }

  void onOptionsSelected(Task task) {
    OptionsDialog.show(options: [
      Option(
        text: task.completed ? Localized.get.optionNotDone : Localized.get.optionDone,
        callback: () => onTaskSelected(task),
      ),
      Option(
        text: Localized.get.optionUpdate,
        callback: () => onUpdateTask(task),
      ),
      Option(
        text: Localized.get.optionDelete,
        callback: () => ConfirmationDialog.show(
          message: Localized.get.confirmationDeleteTask,
          callback: () => onTaskDeleted(task),
        ),
      ),
    ]);
  }

  void onTaskDeleted(Task task) {
    _tasks!.remove(task);
    notify();
    Repository.delete(task);
  }

  void onAddTask() => Navigation.taskScreen();

  void onUpdateTask(Task task) => Navigation.taskScreen(task);
}
