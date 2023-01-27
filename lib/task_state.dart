import 'package:flutter/foundation.dart';

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
