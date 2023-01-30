import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

class TaskState extends ChangeNotifier {
  List<Task>? tasks;

  Future<void> addTask(Task task) async {
    tasks!.add(task);
    AppDatabase.insertTask(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    int selectedTask = tasks!.indexOf(task);
    tasks![selectedTask].completed = true;
    AppDatabase.updateTask(task);

    // rebuild AnimationList, thus can display another view if list is empty
    if (tasks!.where((element) => !element.completed).toList().isEmpty) {
      notifyListeners();
    }
  }

  Future<List<Task>> getTasks() async {
    // ignore: prefer_conditional_assignment
    tasks ??= await AppDatabase.tasks();
    return tasks!;
  }
}
