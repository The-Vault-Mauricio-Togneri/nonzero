import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:nonzero/models/task.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/repository.dart';
import 'package:nonzero/services/routes.dart';
import 'package:nonzero/types/priority.dart';
import 'package:nonzero/widgets/custom_button.dart';
import 'package:nonzero/widgets/custom_form_field.dart';
import 'package:nonzero/widgets/label.dart';

class EditScreen extends StatelessWidget {
  final EditState state;

  const EditScreen(this.state);

  static FadeRoute instance([Task? task]) => FadeRoute(EditScreen(EditState(task)));

  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: StateProvider<EditState>(
        state: state,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Label(
              text: state.hasTask ? 'Edit task' : 'New task',
              color: Palette.white,
              size: 16,
            ),
          ),
          body: Content(state),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  final EditState state;

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
  final EditState state;

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
              label: 'Name',
              autofocus: true,
              controller: state.nameController,
              inputType: TextInputType.text,
            ),
            const VBox(15),
            PrioritySelector(
              state: state,
              priority: Priority.high,
            ),
            const VBox(10),
            PrioritySelector(
              state: state,
              priority: Priority.medium,
            ),
            const VBox(10),
            PrioritySelector(
              state: state,
              priority: Priority.low,
            ),
          ],
        ),
      ),
    );
  }
}

class PrioritySelector extends StatelessWidget {
  final EditState state;
  final Priority priority;

  const PrioritySelector({
    required this.state,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: (state.priority == priority) ? priority.color : Palette.lightGrey,
      child: Material(
        color: Palette.transparent,
        child: InkWell(
          onTap: () => state.onSetPriority(priority),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Label(
                text: priority.name,
                color: Palette.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final EditState state;

  const Buttons(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CustomButton(
        onPressed: state.onSubmit,
        text: state.hasTask ? 'Edit' : 'Add',
      ),
    );
  }
}

class EditState extends BaseState {
  final Task? task;
  Priority priority = Priority.high;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditState(this.task);

  bool get hasTask => task != null;

  void onSetPriority(Priority newPriority) {
    priority = newPriority;
    notify();
  }

  Future onSubmit() async {
    if (formKey.currentState!.validate()) {
      Keyboard.hide(Routes.context());

      final Task task = await Repository.add(Task(
        id: '',
        name: nameController.text.trim(),
        priority: priority,
        completed: false,
      ));

      Routes.pop(task);
    }
  }
}
