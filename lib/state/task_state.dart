import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

class TaskState extends ChangeNotifier {
  List<Task>? tasks;
  AppDatabase database = AppDatabase();

  Future<int> addTask(Task task) async {
    tasks!.add(task);
    int taskId = await database.insertTask(task);
    notifyListeners();
    return taskId;
  }

  void markTaskAsCompleted(Task task) {
    int selectedTask = tasks!.indexOf(task);
    tasks![selectedTask].completed = true;
    database.updateTask(task);

    // rebuild AnimationList, thus can display another view if list is empty
    if (tasks!.where((element) => !element.completed).toList().isEmpty) {
      notifyListeners();
    }
  }

  Future<List<Task>> getTasks() async {
    // ignore: prefer_conditional_assignment
    tasks ??= await database.tasks();
    return tasks!;
  }
}
