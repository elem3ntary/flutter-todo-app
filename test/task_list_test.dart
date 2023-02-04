import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';
import 'package:todo_app/screens/task_list.dart';
import 'package:todo_app/state/task_state.dart';
import 'dart:developer' as dev;

import 'utils.dart';

Widget createTaskListPage(TaskState taskState) {
  return ChangeNotifierProvider<TaskState>(
    create: (context) => taskState,
    builder: (context, child) {
      return MaterialApp(
        theme: appThemeData(),
        home: TaskListPage(),
      );
    },
  );
}

void main() {
  const emptyTaskListWidget = Key('emptyTaskListWidget');
  final taskState = TaskState();
  late AppDatabase db;

  setUp(() async => {
    db = await getTestDatabase();
  });

  testWidgets('Newly added tasks are diplayed in the task list',
      (tester) async {
    await tester.pumpWidget(createTaskListPage(taskState));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    // int frames = await tester.pumpAndSettle();
    // dev.log('Frames pumped: $frames');
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(emptyTaskListWidget), findsOneWidget);

    const testTaskName = 'test task';
    taskState.addTask(Task(testTaskName));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(testTaskName), findsOneWidget);
  });
}
