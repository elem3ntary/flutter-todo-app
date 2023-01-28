import 'package:flutter/foundation.dart';
import 'package:todo_app/task.dart';

class TaskState extends ChangeNotifier {
  var tasks = <Task>[Task('Some cool name', progressTabsCount: 3)];

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
