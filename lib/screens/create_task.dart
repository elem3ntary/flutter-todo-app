import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/state/task_state.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _controller = TextEditingController();

  bool _valid = true;

  @override
  void initState() {
    _controller.addListener(_checkIfNameIsValid);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkIfNameIsValid() {
    setState(() {
      _valid = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text('Add new task'),
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.create),
            ],
          )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'Enter task name',
                    errorText: _valid ? null : "Field cannot be empty"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          _checkIfNameIsValid();
          if (!_valid) {
            return;
          }
          state.addTask(Task(_controller.text));
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
