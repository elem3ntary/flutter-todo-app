import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

class TaskState extends ChangeNotifier {
  var tasks = <Task>[Task('Some cool name', progressTabsCount: 3)];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    int selectedTask = tasks.indexOf(task);
    tasks[selectedTask].completed = true;
    notifyListeners();
  }

  List<Task> getTasks() {
    return tasks.where((element) => !element.completed).toList();
  }
}
