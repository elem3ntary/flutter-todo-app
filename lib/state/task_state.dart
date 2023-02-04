import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

class TaskState extends ChangeNotifier {
  List<Task>? tasks;
  AppDatabase? database;

  Future<void> initIfNeeded() async {
    database ??= await AppDatabase.create();
  }

  Future<int> addTask(Task task) async {
    await initIfNeeded();
    tasks!.add(task);
    int taskId = await database!.insertTask(task);
    notifyListeners();
    return taskId;
  }

  Future<void> addFeeling(String feeling, Task task) async {
    await initIfNeeded();
    task.addFeeling(feeling);
    await database!.updateTask(task);
    notifyListeners();
  }

  Future<void> markTaskAsCompleted(Task task) async {
    await initIfNeeded();
    task.completed = true;
    await database!.updateTask(task);

    notifyListeners();
    // causes task list widget to rebuild thus AnimationList is replaced by
    // widget that notifies that all tasks are completed
    if (tasks!
        .where((el) => !el.completed && el.ancestorTaskId == null)
        .toList()
        .isEmpty) {
      notifyListeners();
    }
  }

  Future<List<Task>> getTasks() async {
    await initIfNeeded();
    // ignore: prefer_conditional_assignment
    tasks ??= await database!.tasks();
    return tasks!;
  }

  Future<void> fetchSubtasks(Task task) async {
    await initIfNeeded();
    task.subtasks = await database!.fetchSutasks(task);
  }
}
