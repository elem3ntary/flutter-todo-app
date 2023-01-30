import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/zenmode.dart';

import '../models/task.dart';
import '../state/task_state.dart';

class TodoTile extends StatelessWidget {
  const TodoTile(
    this.task, {
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var iconData = task.completed ? Icons.circle : Icons.circle_outlined;
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ZenMode(task)))
      },
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              task.name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              ),
            ),
            Container(
              // margin: const EdgeInsets.symmetric(horizontal: 22),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  state.markTaskAsCompleted(task);
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
