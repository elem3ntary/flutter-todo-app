import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/create_task.dart';
import 'package:todo_app/task.dart';
import 'package:todo_app/zenmode.dart';

import 'task_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var defaultColorScheme = ThemeData.dark().colorScheme;
    var baseTheme = ThemeData.dark();
    var themeData = baseTheme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
      colorScheme: defaultColorScheme.copyWith(
          background: const Color(0xff304163),
          secondary: const Color(0xff516C8D)),
    );
    return MaterialApp(theme: themeData, home: const MainPage());
  }
}

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

class TodoTile extends StatelessWidget {
  const TodoTile(
    this.task, {
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var iconData = task.done ? Icons.circle : Icons.circle_outlined;
    return GestureDetector(
      onLongPress: () => {
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
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
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
            Text(
              task.name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
