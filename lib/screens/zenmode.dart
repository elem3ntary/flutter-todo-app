// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/feeling_input.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/common_widgets/zenmode_card.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/state/task_state.dart';

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

  Widget _displayFeelingSection() {
    if (widget.task.getFeelingCount() > 0) {
      return Text(
        widget.task.getLastFeeling(),
        style: const TextStyle(fontSize: 24),
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
          // TODO: bugs with Future builder are present.
          // when deleting item how to update internal data structure
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
