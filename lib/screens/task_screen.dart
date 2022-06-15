import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/services/localizations.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/repository.dart';
import 'package:nonzero/services/routes.dart';
import 'package:nonzero/types/priority.dart';
import 'package:nonzero/widgets/custom_button.dart';
import 'package:nonzero/widgets/custom_form_field.dart';
import 'package:nonzero/widgets/label.dart';
import 'package:nonzero/widgets/screen_container.dart';

class TaskScreen extends StatelessWidget {
  final TaskState state;

  const TaskScreen(this.state);

  static FadeRoute<bool?> instance([Task? task]) => FadeRoute(TaskScreen(TaskState(task)));

  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: ScreenContainer(
        child: StateProvider<TaskState>(
          state: state,
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Label(
                text: state.hasTask ? Localized.get.taskTitleUpdate : Localized.get.taskTitleNew,
                color: Palette.white,
                size: 16,
              ),
              leading: IconButton(
                onPressed: () => Routes.pop(false),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Content(state),
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final TaskState state;

  const Content(this.state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Fields(state),
        const Spacer(),
        Buttons(state),
      ],
    );
  }
}

class Fields extends StatelessWidget {
  final TaskState state;

  const Fields(this.state);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
        child: Column(
          children: [
            CustomFormField(
              label: Localized.get.taskFieldName,
              autofocus: true,
              controller: state.nameController,
              inputType: TextInputType.text,
            ),
            const VBox(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PrioritySelector(
                  state: state,
                  priority: Priority.high,
                ),
                const HBox(10),
                PrioritySelector(
                  state: state,
                  priority: Priority.medium,
                ),
                const HBox(10),
                PrioritySelector(
                  state: state,
                  priority: Priority.low,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PrioritySelector extends StatelessWidget {
  final TaskState state;
  final Priority priority;

  const PrioritySelector({
    required this.state,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: (state.priority == priority) ? priority.color : Palette.lightGrey,
        child: Material(
          color: Palette.transparent,
          child: InkWell(
            onTap: () => state.onSetPriority(priority),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Label(
                  text: priority.text,
                  color: Palette.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final TaskState state;

  const Buttons(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CustomButton(
        onPressed: state.onSubmit,
        text: state.hasTask ? Localized.get.taskButtonUpdate : Localized.get.taskButtonAdd,
      ),
    );
  }
}

class TaskState extends BaseState {
  final Task? task;
  Priority priority = Priority.high;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TaskState(this.task);

  @override
  void onLoad() {
    if (task != null) {
      nameController.text = task!.name;
      priority = task!.priority;
    }
  }

  bool get hasTask => task != null;

  void onSetPriority(Priority newPriority) {
    priority = newPriority;
    notify();
  }

  Future onSubmit() async {
    if (formKey.currentState!.validate()) {
      Keyboard.hide(Routes.context());

      if (task != null) {
        final Task updatedTask = Task(
          id: task!.id,
          name: nameController.text.trim(),
          priority: priority,
          completed: task!.completed,
        );

        await Repository.update(updatedTask);
        Routes.pop(true);
      } else {
        await Repository.add(Task(
          id: '',
          name: nameController.text.trim(),
          priority: priority,
          completed: false,
        ));
        Routes.pop(true);
      }
    }
  }
}
