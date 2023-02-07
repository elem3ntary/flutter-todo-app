// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/feeling_input.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/common_widgets/zenmode_card.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/feeling.dart';

class ZenMode extends StatefulWidget {
  final Task task;
  const ZenMode(this.task, {super.key});

  @override
  State<ZenMode> createState() => _ZenModeState();
}

class _ZenModeState extends State<ZenMode> {
  final loading = const Center(
    child: RefreshProgressIndicator(),
  );
  final zenModeTitle = Text(
    'Zen mode'.toUpperCase(),
    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
  );
  final contentVerticalMargin = const SizedBox(height: 30);

  void _navigateToFeeling(String feeling) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeelingPage(
            feeling: feeling,
          ),
        ));
  }

  String limitedLengthString(String value, {int length = 20}) {
    final end = min(value.length - 1, length);
    final substring = value.substring(0, end);
    return '$substring...';
  }

  Widget _displayFeelingSection() {
    if (widget.task.getFeelingCount() > 0) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              limitedLengthString(widget.task.getLastFeeling(), length: 200),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
              onPressed: () => _navigateToFeeling(widget.task.getLastFeeling()),
              child: const Text('View more'))
        ],
      );
    }
    return const Text('Nothing yet');
  }

  Widget pageContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            zenModeTitle,
            contentVerticalMargin,
            ZenModeCard(task: widget.task),
            contentVerticalMargin,
            SubTaskTodoTile(task: widget.task),
            contentVerticalMargin,
            FeelingInput(
              task: widget.task,
            ),
            contentVerticalMargin,
            const Text('Last feeling'),
            contentVerticalMargin,
            _displayFeelingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return loading;
    }
    return pageContent();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var state = context.watch<TaskState>();

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: FutureBuilder(
          future: state.fetchSubtasks(widget.task),
          builder: _buildContent,
        ));
  }
}

class SubTaskTodoTile extends StatefulWidget {
  const SubTaskTodoTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<SubTaskTodoTile> createState() => _SubTaskTodoTileState();
}

class _SubTaskTodoTileState extends State<SubTaskTodoTile> {
  Task? subtask;

  void setSubtask() {
    setState(() {
      subtask = widget.task.subtasks!
          .firstWhereOrNull((element) => !element.completed);
    });
  }

  @override
  void didChangeDependencies() {
    setSubtask();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (subtask == null) {
      return const SizedBox(
          height: 72, child: Center(child: Text('All subtasks completed!')));
    }

    return SizedBox(
        width: 400,
        child: TodoTile(
          subtask!,
          onCompleted: setSubtask,
          tappable: false,
        ));
  }
}
