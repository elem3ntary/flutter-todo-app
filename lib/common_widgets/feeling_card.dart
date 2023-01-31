import 'package:flutter/material.dart';

class FeelingCard extends StatefulWidget {
  const FeelingCard({super.key, required this.feeling});

  static const selectedColor = Color(0xff598D51);
  final String feeling;

  @override
  State<FeelingCard> createState() => _FeelingCardState();
}

class _FeelingCardState extends State<FeelingCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(11),
        width: 80,
        height: 50,
        decoration: BoxDecoration(
            color: selected
                ? FeelingCard.selectedColor
                : theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: Text(
          widget.feeling,
          style: const TextStyle(fontSize: 32),
        )),
      ),
    );
  }
}
