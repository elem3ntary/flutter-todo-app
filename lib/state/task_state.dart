import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

class TaskState extends ChangeNotifier {
  List<Task>? tasks;
  AppDatabase? database;

  Future<void> init() async {
    database ??= await AppDatabase.create();
  }

  Future<int> addTask(Task task) async {
    tasks!.add(task);
    int taskId = await database!.insertTask(task);
    notifyListeners();
    return taskId;
  }

  void addFeeling(String feeling, Task task) {
    task.addFeeling(feeling);
    database!.updateTask(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    task.completed = true;
    database!.updateTask(task);

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
    // ignore: prefer_conditional_assignment
    tasks ??= await database!.tasks();
    return tasks!;
  }

  Future<void> fetchSubtasks(Task task) async {
    task.subtasks = await database!.fetchSutasks(task);
  }
}
