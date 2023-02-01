import 'package:flutter/material.dart';

class FeelingCard extends StatefulWidget {
  const FeelingCard(
      {super.key, required this.feeling, required this.onSelectedChanged});

  static const selectedColor = Color(0xff598D51);
  final String feeling;
  final void Function(bool selected) onSelectedChanged;

  @override
  State<FeelingCard> createState() => _FeelingCardState();
}

class _FeelingCardState extends State<FeelingCard> {
  bool selected = false;

  void toggleSelected() {
    selected = !selected;
    widget.onSelectedChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(toggleSelected);
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
