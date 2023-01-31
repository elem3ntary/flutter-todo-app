import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FixedWidthStopwatch extends StatefulWidget {
  const FixedWidthStopwatch(
      {super.key, this.initialDuration = Duration.zero, this.textStyle});

  final Duration initialDuration;
  final TextStyle? textStyle;

  @override
  State<FixedWidthStopwatch> createState() => _FixedWidthStopwatchState();
}

class _FixedWidthStopwatchState extends State<FixedWidthStopwatch> {
  final _taskStopWatch = Stopwatch();
  late final Duration _duration;
  late Timer _taskTimer;

  void _startTaskTimer() {
    _taskStopWatch.reset();
    _taskStopWatch.start();
    _taskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _taskStopWatch.elapsed;
      });
    });
  }

  @override
  void initState() {
    _duration = widget.initialDuration;
    _startTaskTimer();
    super.initState();
  }

  @override
  void dispose() {
    _endTaskTimer();
    super.dispose();
  }

  void _endTaskTimer() {
    _taskStopWatch.stop();
    _taskTimer.cancel();
  }

  double _getTextWidth(String text, BuildContext context) {
    final Size size = (TextPainter(
            text: TextSpan(text: text, style: widget.textStyle),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    return size.width;
  }

  double _getMaxLetterWidth(List<String> letters, BuildContext context) {
    return letters.map((letter) => _getTextWidth(letter, context)).reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    var numbers =
        List<int>.generate(10, (i) => i).map((e) => e.toString()).toList();
    double maxLetterLength = _getMaxLetterWidth(numbers, context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FixedSizeText(
            (_duration.inMinutes / 10).floor().toString(), maxLetterLength,
            textStyle: widget.textStyle),
        FixedSizeText(
            _duration.inMinutes.remainder(10).toString(), maxLetterLength,
            textStyle: widget.textStyle),
        Text(
          ':',
          style: widget.textStyle,
        ),
        FixedSizeText(
            (_duration.inSeconds.remainder(60) / 10).floor().toString(),
            maxLetterLength,
            textStyle: widget.textStyle),
        FixedSizeText(
            _duration.inSeconds.remainder(60).remainder(10).toString(),
            maxLetterLength,
            textStyle: widget.textStyle),
      ],
    );
  }
}

class FixedSizeText extends StatelessWidget {
  /// Makes text
  const FixedSizeText(
    this.text,
    this.width, {
    super.key,
    required this.textStyle,
  });

  final String text;
  final double width;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var textWidget = Text(
      text,
      style: textStyle,
    );

    return SizedBox(
      width: width,
      child: Center(child: textWidget),
    );
  }
}
