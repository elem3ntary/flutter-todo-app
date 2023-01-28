import 'dart:math';

import 'package:flutter/material.dart';

class FixedWidthStopwatch extends StatelessWidget {
  const FixedWidthStopwatch(
      {super.key, required this.duration, this.textStyle});

  final Duration duration;
  final TextStyle? textStyle;

  double _getTextWidth(String text, BuildContext context) {
    final Size size = (TextPainter(
            text: TextSpan(text: text, style: textStyle),
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
            (duration.inMinutes / 10).floor().toString(), maxLetterLength,
            textStyle: textStyle),
        FixedSizeText(
            duration.inMinutes.remainder(10).toString(), maxLetterLength,
            textStyle: textStyle),
        Text(
          ':',
          style: textStyle,
        ),
        FixedSizeText(
            (duration.inSeconds.remainder(60) / 10).floor().toString(),
            maxLetterLength,
            textStyle: textStyle),
        FixedSizeText(duration.inSeconds.remainder(60).remainder(10).toString(),
            maxLetterLength,
            textStyle: textStyle),
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
