import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/feeling_card.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/state/task_state.dart';

class FeelingInput extends StatefulWidget {
  const FeelingInput({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<FeelingInput> createState() => _FeelingInputState();
}

class _FeelingInputState extends State<FeelingInput> {
  final selectedFeelings = <String>[];

  final _textEditingController = TextEditingController();

  void _onSelectedChanged(bool value, String feeling) {
    if (value) {
      selectedFeelings.add(feeling);
    } else {
      selectedFeelings.remove(feeling);
    }
  }

  void _onTextFiledSubmitted(String value, TaskState state) {
    if (value.trim().isEmpty) {
      return;
    }
    final feeling = selectedFeelings.join(' ');
    state.addFeeling('$feeling $value', widget.task);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskState>();
    return Column(
      children: [
        const Text('How do you feel about the task?',
            style: TextStyle(fontSize: 15)),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var feeling in widget.task.availableFeelings)
              FeelingCard(
                feeling: feeling,
                onSelectedChanged: (value) =>
                    _onSelectedChanged(value, feeling),
              ),
          ],
        ),
        const SizedBox(height: 40),
        const Text('Describe your feeling and what to do next?'),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter text',
            ),
            onSubmitted: (value) => _onTextFiledSubmitted(value, state),
          ),
        ),
      ],
    );
  }
}
