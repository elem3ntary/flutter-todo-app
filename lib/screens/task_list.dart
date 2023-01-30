import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/screens/create_task.dart';
import '../state/task_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var tasks = state.getTasks();
    var themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          if (tasks.isEmpty)
            Expanded(
                child: Center(
              child: Text('No tasks. Good work!'),
            )),
          if (tasks.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: ((context, index) => TodoTile(tasks[index]))),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewTask()));
        },
        child: const IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
