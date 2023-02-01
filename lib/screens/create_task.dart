import 'dart:developer' as dev;

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
  final subtaskControllerList = <TextEditingController>[];
  final GlobalKey<AnimatedListState> listState = GlobalKey();
  final FocusNode _nameFocusNode = FocusNode();

  bool _valid = true;

  @override
  void initState() {
    _nameFocusNode.addListener(_checkIfNameIsValid);
    subtaskControllerList.add(TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _checkIfNameIsValid() {
    if (_nameFocusNode.hasFocus) {
      return;
    }
    setState(() {
      _valid = _controller.text.isNotEmpty;
    });
  }

  void _onInsertionModeChange() {
    // If there does not exist TextFiled with insertionMode = true, add new one
    if (subtaskControllerList[subtaskControllerList.length - 1]
        .text
        .isNotEmpty) {
      subtaskControllerList.add(TextEditingController());
      listState.currentState!.insertItem(subtaskControllerList.length - 1);
    }
  }

  void _onItemDeletePressed(index) {
    var controller = subtaskControllerList[index];
    subtaskControllerList.removeAt(index);
    controller.dispose();
    listState.currentState!.removeItem(
        index,
        (context, animation) => _buildSubtaskItem(context, index, animation,
            controller: TextEditingController(text: 'test test')));
  }

  Future<void> addTask(TaskState state) async {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _valid = false;
      });
      return;
    }
    final task = Task(_controller.text);
    final taskId = await state.addTask(task);
    for (var i = 0; i < subtaskControllerList.length; i++) {
      final subtaskController = subtaskControllerList[i];
      if (subtaskController.text.trim().isEmpty) {
        continue;
      }
      final subTask =
          Task(subtaskController.text, ancestorTaskId: taskId, subtaskIndex: i);
      await state.addTask(subTask);
    }
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
                focusNode: _nameFocusNode,
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'Enter task name',
                    errorText: _valid ? null : "Field cannot be empty"),
              ),
            ),
            Expanded(
              child: AnimatedList(
                  key: listState,
                  initialItemCount: subtaskControllerList.length,
                  itemBuilder: (context, index, animation) => _buildSubtaskItem(
                      context, index, animation,
                      controller: subtaskControllerList[index])),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          _checkIfNameIsValid();
          setState(() {
            _valid = _controller.text.trim().isNotEmpty;
          });
          if (!_valid) {
            return;
          }
          addTask(state);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildSubtaskItem(
      BuildContext context, int index, Animation<double> animation,
      {TextEditingController? controller}) {
    final tween = Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero);
    return SlideTransition(
      position: animation.drive(tween),
      child: RemovableTextField(
        textEditingController: controller ?? TextEditingController(),
        onInsertionModeChange: _onInsertionModeChange,
        onItemDeletePressed: () => _onItemDeletePressed(index),
      ),
    );
  }
}

class RemovableTextField extends StatefulWidget {
  const RemovableTextField({
    super.key,
    required this.textEditingController,
    required this.onInsertionModeChange,
    this.textFieldValue,
    required this.onItemDeletePressed,
  });
  final TextEditingController textEditingController;
  final Function onInsertionModeChange;
  final VoidCallback onItemDeletePressed;
  final String? textFieldValue;

  @override
  State<RemovableTextField> createState() => _RemovableTextFieldState();
}

class _RemovableTextFieldState extends State<RemovableTextField> {
  bool get _insertionMode => widget.textEditingController.text.isEmpty;

  void setInsertionMode(value) {
    dev.log('setting insertion mode to $value');
    if (_insertionMode != value) {
      widget.onInsertionModeChange();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
              hintText: _insertionMode ? 'Add new subtask' : 'Edit subtask',
              prefixIcon: _insertionMode
                  ? const Icon(Icons.add)
                  : const Icon(Icons.edit),
            ),
            onChanged: (value) {
              widget.onInsertionModeChange();
              dev.log('Text filed value change to $value');
              setInsertionMode(value.trim().isEmpty);
            },
          ),
        ),
        if (!_insertionMode)
          IconButton(
            onPressed: widget.onItemDeletePressed,
            icon: const Icon(Icons.delete),
          )
      ]),
    );
  }
}
