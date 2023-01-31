import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/common_widgets/feeling_card.dart';
import 'package:todo_app/common_widgets/fixed_width_stopwatch.dart';
import 'package:todo_app/common_widgets/single_progress_bar.dart';
import 'package:todo_app/models/task.dart';

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

    var cardWidth = 314;
    var progressTabsCount = widget.task.progressTabsCount;
    var taskProgress = widget.task.getProgres();
    var availableFeelings = ['😳', '😖', '😀'];

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 132),
              Text(
                'Zen mode'.toUpperCase(),
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 125),
              ZenModeCard(cardColor: cardColor, widget: widget),
              const SizedBox(height: 14),
              const SizedBox(height: 93),
              const Text('How do you feel about the task?',
                  style: TextStyle(fontSize: 15)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var feeling in availableFeelings)
                    FeelingCard(
                      feeling: feeling,
                    ),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Describe your feeling and what to do next?'),
              const SizedBox(height: 20),
              const SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Enter text'),
                  ))
            ],
          ),
        ));
  }
}

class ZenModeCard extends StatefulWidget {
  const ZenModeCard({
    super.key,
    required this.cardColor,
    required this.widget,
  });

  final Color cardColor;
  final ZenMode widget;

  @override
  State<ZenModeCard> createState() => _ZenModeCardState();
}

class _ZenModeCardState extends State<ZenModeCard> {
  late Timer _timer;
  final _taskStopWatch = Stopwatch();
  late Timer _taskTimer;
  String timerText = '00:00';
  late Timer _animationUpdateTimer;
  double borderWidth = 0;
  Color borderColor = const Color.fromARGB(0, 255, 230, 0);

  void startTimer() {
    startAnimationTimer();
    _timer = Timer(const Duration(seconds: 1, milliseconds: 400), () {
      resetAnimationTimer();
      endTaskTimer();
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

  void startTaskTimer() {
    _taskStopWatch.reset();
    _taskStopWatch.start();
    _taskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.widget.task.time = _taskStopWatch.elapsed;
        timerText = widget.widget.task.getReadableTime();
      });
    });
  }

  void endTaskTimer() {
    _taskStopWatch.stop();
    _taskTimer.cancel();
  }

  @override
  void initState() {
    startTaskTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        startTimer();
      },
      onTapUp: (_) {
        _timer.cancel();
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
                  widget.widget.task.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FixedWidthStopwatch(
                  duration: widget.widget.task.time,
                  textStyle: const TextStyle(fontSize: 16),
                )
              ],
            ),
            const SizedBox(height: 40),
            const SingleProgressBar(
              cardWidth: 200,
              isCompleted: false,
            ),
          ]),
        ),
      ),
    );
  }
}
