import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common_widgets/todo_tile.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';
import 'package:todo_app/screens/task_list.dart';
import 'package:todo_app/state/task_state.dart';
import 'dart:developer' as dev;
import 'package:todo_app/screens/create_task.dart';

import 'utils.dart';

Widget createTaskListPage(TaskState taskState) {
  return ChangeNotifierProvider<TaskState>(
    create: (context) => taskState,
    builder: (context, child) {
      return MaterialApp(
        // theme: appThemeData(),
        home: TaskListPage(),
      );
    },
  );
}

void main() {
  const emptyTaskListWidget = Key('emptyTaskListWidget');
  const standartDuration = Duration(seconds: 4);
  const oneSecondDuration = Duration(seconds: 1);
  const addButtonKey = Key('addTask');
  const addScreenText = Key('addTaskText');
  const testTaskName = 'test name';
  const testSubTaskName = 'a cool subtask';
  const subtaskKey = Key('subtaskTextField_0');

  // TODO: tests are broken. Look into it later.

  late AppDatabase db;
  late TaskState taskState;

  setUp(() async {
    db = await getTestDatabase();
    taskState = TaskState();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() async {
    await db.deleteAppDatabase();
    // taskState.dispose();
  });

  // Navigates from the task list to the Create task screen and creates new task
  // with parameters [taskName] and [subTaskName]
  Future<void> createTask(
      dynamic tester, String taskName, String subTaskName) async {
    await tester.tap(find.byKey(addButtonKey));
    await tester.pump(oneSecondDuration);
    await tester.pump(oneSecondDuration);
    expect(find.byKey(addScreenText), findsOneWidget);
    await tester.enterText(find.byKey(taskNameFieldKey), taskName);
    await tester.enterText(find.byKey(subtaskKey), subTaskName);

    await tester.tap(find.byKey(taskSubmitButtonKey));
  }

  testWidgets('Newly added tasks are diplayed in the task list',
      (tester) async {
    await tester.runAsync(() async {
      final state = TaskState();
      await tester.pumpWidget(createTaskListPage(state));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(standartDuration);
      await tester.pump(const Duration(seconds: 4));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(emptyTaskListWidget), findsOneWidget);

      const testTaskName = 'test task';
      await state.addTask(Task(testTaskName));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text(testTaskName), findsOneWidget);
    });
  });

  testWidgets('User can add task via UI', (tester) async {
    await tester.runAsync(() async {
      final state = TaskState();
      await tester.pumpWidget(createTaskListPage(state));
      await tester.pump(standartDuration);
      await tester.pump(standartDuration);

      await createTask(tester, testTaskName, testSubTaskName);
      await tester.pumpAndSettle();
      expect(find.textContaining(testTaskName), findsOneWidget);

      await tester.tap(find.ancestor(
          of: find.textContaining(testTaskName),
          matching: find.byType(TodoTile)));
      await tester.pumpAndSettle();
      expect(find.textContaining(testSubTaskName), findsOneWidget);
    });
  });

  testWidgets('Task disappears from task list if it is completed',
      (tester) async {
    await tester.runAsync(() async {
      final state = TaskState();
      await tester.pumpWidget(createTaskListPage(state));
      await tester.pump(standartDuration);
      await tester.pump(standartDuration);

      await createTask(tester, testTaskName, testSubTaskName);
      await tester.pumpAndSettle();
      expect(find.textContaining(testTaskName), findsOneWidget);

      final circleButton = find.byType(IconButton);
      expect(circleButton, findsOneWidget);
      await tester.tap(circleButton);
      await tester.pump(oneSecondDuration);
      await tester.pump(oneSecondDuration);

      expect(find.textContaining(testTaskName), findsNothing);
    });
  });
}
