import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

import '../utils.dart';

void main() {
  final testTask =
      Task('task with some name', description: 'some cool description');
  final testSubTasksNames = ['s1', 's2', 's3'];

  setUp(() {
    return getTestDatabase();
  });

  tearDown(() async {
    final db = await AppDatabase.create();
    await db.close();
    await db.deleteAppDatabase();
  });

  List<Task> generateSubtasks(List<String> names, int ancestorId) {
    return names.map((e) => Task(e, ancestorTaskId: ancestorId)).toList();
  }

  Future<List<Task>> getTasksFromDB(Database db) async {
    final dbResult = await db.query(AppDatabase.tableName);
    final dbTasks = AppDatabase.databaseResultToTaskList(dbResult);
    return dbTasks;
  }

  test('Newly added task is persistant', () async {
    final appDatabase = await AppDatabase.create();
    final db = appDatabase.database;
    final state = TaskState();
    var tasks = await appDatabase.tasks();
    expect(tasks.length, 0);

    await state.addTask(testTask);
    final dbTasks = await getTasksFromDB(db);

    tasks = await appDatabase.tasks();
    expect(tasks.length, 1);
    final testTaskFromDB = dbTasks.first;
    expect(testTaskFromDB.name, testTask.name);
    expect(testTaskFromDB.description, testTask.description);

    final testTaskFromState = dbTasks.first;
    expect(testTaskFromState.name, testTask.name);
    expect(testTaskFromState.description, testTask.description);
  });

  test('Subtasks are persitant', () async {
    final appDatabase = await AppDatabase.create();
    final db = appDatabase.database;
    final state = TaskState();

    int ancestorTaskId = await state.addTask(testTask);
    for (var subTask in generateSubtasks(testSubTasksNames, ancestorTaskId)) {
      await state.addTask(subTask);
    }

    final dbTasks = await getTasksFromDB(db);
    expect(dbTasks.length, testSubTasksNames.length + 1);
    expect(
        dbTasks.where((value) => testSubTasksNames.contains(value.name)).length,
        testSubTasksNames.length);
  });
}
