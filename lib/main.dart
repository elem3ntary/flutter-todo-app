import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskState(),
      child: const MainApp(),
    ),
  );
}

class Task {
  bool done = false;
  String name;
  Task(this.name);
}

class TaskState extends ChangeNotifier {
  var tasks = <Task>[];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    int selectedTask = tasks.indexOf(task);
    tasks[selectedTask].done = true;
    notifyListeners();
  }

  List<Task> getTasks() {
    return tasks.where((element) => !element.done).toList();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskState>();
    var defaultColorScheme = ThemeData.dark().colorScheme;
    var baseTheme = ThemeData.dark();
    var themeData = baseTheme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
      colorScheme: defaultColorScheme.copyWith(
          background: const Color(0xff1B263B),
          secondary: const Color(0xff778DA9)),
    );
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        backgroundColor: themeData.colorScheme.background,
        body: const MainPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => state.addTask(Task('test')),
          child: const IconTheme(
            data: IconThemeData(color: Colors.white),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
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
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: ((context, index) => TodoTile(tasks[index]))),
        ),
      ],
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
    return Container(
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
              onPressed: () {
                state.markTaskAsCompleted(task);
              },
              icon: Icon(
                iconData,
                size: 35,
                weight: 1,
              ),
            ),
          ),
          Text(
            'some title',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
