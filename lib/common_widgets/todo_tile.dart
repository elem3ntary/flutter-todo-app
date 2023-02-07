import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/zenmode.dart';

import '../models/task.dart';

class TodoTile extends StatelessWidget {
  const TodoTile(
    this.task, {
    super.key,
    required this.onCompleted,
    this.tappable = true,
  });

  final Task task;
  final Function onCompleted;
  final bool tappable;

  Widget _buildTaskTitle({required double fontSize}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        task.name,
        style: TextStyle(fontSize: fontSize),
        softWrap: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var iconData = task.completed ? Icons.circle : Icons.circle_outlined;
    final titleFontSize = Theme.of(context).textTheme.titleLarge!.fontSize!;
    return GestureDetector(
      onTap: () {
        if (!tappable) {
          return;
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ZenMode(task)));
      },
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: _buildTaskTitle(
                fontSize: titleFontSize,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  state.markTaskAsCompleted(task);
                  onCompleted();
                },
                icon: Center(
                  child: Icon(
                    iconData,
                    size: 35,
                    weight: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
