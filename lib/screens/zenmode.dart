// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/feeling_card.dart';
import 'package:todo_app/common_widgets/fixed_width_stopwatch.dart';
import 'package:todo_app/common_widgets/single_progress_bar.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/state/task_state.dart';

class ZenMode extends StatefulWidget {
  final Task task;
  const ZenMode(this.task, {super.key});

  @override
  State<ZenMode> createState() => _ZenModeState();
}

class _ZenModeState extends State<ZenMode> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var cardColor = const Color(0xff28385E);
    var state = context.watch<TaskState>();

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: true,
        body: FutureBuilder(
          // TODO: bugs with Future builder are present.
          // when deleting item how to update internal data structure
          future: state.fetchSubtasks(widget.task),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: RefreshProgressIndicator(),
              );
            }
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // const SizedBox(height: 132),
                    Text(
                      'Zen mode'.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    ZenModeCard(cardColor: cardColor, task: widget.task),
                    const SizedBox(height: 30),
                    SubTaskTodoTile(task: widget.task),
                    const SizedBox(height: 40),
                    FeelingInput(
                      task: widget.task,
                    ),
                    const SizedBox(height: 20),
                    const Text('Last feeling'),
                    const SizedBox(height: 20),
                    if (widget.task.getFeelingCount() > 0)
                      Text(
                        widget.task.getLastFeeling(),
                        style: const TextStyle(fontSize: 24),
                      )
                    else
                      const Text('Nothing yet'),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

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

class ZenModeCard extends StatefulWidget {
  const ZenModeCard({
    super.key,
    required this.cardColor,
    required this.task,
  });

  final Color cardColor;
  final Task task;

  @override
  State<ZenModeCard> createState() => _ZenModeCardState();
}

class _ZenModeCardState extends State<ZenModeCard> {
  late Timer _animationDurationTimer;
  late Timer _animationUpdateTimer;

  double borderWidth = 0;
  Color borderColor = const Color.fromARGB(0, 255, 230, 0);

  void startAnimationDurationTimer() {
    startAnimationTimer();
    _animationDurationTimer =
        Timer(const Duration(seconds: 1, milliseconds: 400), () {
      resetAnimationTimer();
      Navigator.pop(context);
    });
  }

  void startAnimationTimer() {
    _animationUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        borderColor = borderColor.withAlpha(borderColor.alpha + 30);
      });
    });
  }

  void resetAnimationTimer() {
    _animationUpdateTimer.cancel();
    setState(() {
      borderColor = borderColor.withAlpha(0);
    });
  }

  double getProgressBarWidth(double totalWidth, int barsCount,
      {double padding = 8}) {
    // TODO: size overflows
    return totalWidth / barsCount - padding;
  }

  @override
  Widget build(BuildContext context) {
    final subtasks = widget.task.subtasks;
    final progressBarWidth = getProgressBarWidth(308, subtasks!.length);
    return GestureDetector(
      onTapDown: (_) {
        startAnimationDurationTimer();
      },
      onTapUp: (_) {
        _animationDurationTimer.cancel();
        resetAnimationTimer();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 159,
        width: 354,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 4),
          color: widget.cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 19),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FixedWidthStopwatch(
                  initialDuration: widget.task.time,
                  textStyle: const TextStyle(fontSize: 16),
                )
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                if (widget.task.subtasks!.length > 1)
                  for (var i = 0; i < widget.task.subtasks!.length; i++)
                    SingleProgressBar(
                      cardWidth: progressBarWidth,
                      isCompleted: widget.task.subtasks![i].completed,
                    ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
