import 'package:flutter/material.dart';

class SingleProgressBar extends StatelessWidget {
  const SingleProgressBar({
    super.key,
    required this.cardWidth,
    this.isCompleted = false,
  });

  final double cardWidth;
  final bool isCompleted;
  static const double barRightMargin = 8;

  @override
  Widget build(BuildContext context) {
    var grayColor = const Color(0xffD9D9D9);
    return Container(
      width: cardWidth,
      height: 15,
      margin: const EdgeInsets.only(right: barRightMargin),
      decoration: BoxDecoration(
          border: Border.all(color: grayColor, width: 2),
          borderRadius: BorderRadius.circular(20),
          color: isCompleted ? grayColor : Colors.transparent),
    );
  }
}
