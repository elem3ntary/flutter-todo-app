import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/common_widgets/fixed_width_stopwatch.dart';
import 'package:todo_app/common_widgets/single_progress_bar.dart';
import 'package:todo_app/models/task.dart';

class ZenModeCard extends StatefulWidget {
  const ZenModeCard({
    super.key,
    required this.task,
  });

  final Task task;
  final cardColor = const Color(0xff28385E);

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
