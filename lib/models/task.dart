import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/persistance.dart';

class Task {
  int? id;
  bool completed;
  String name;
  String? description;
  int? ancestorTaskId;
  int? subtaskIndex;

  List<Task>? subtasks;

  Duration time = const Duration(seconds: 0);
  String feeling;
  final availableFeelings = ['😳', '😖', '😀'];

  Task(this.name,
      {this.description,
      this.id,
      this.completed = false,
      this.ancestorTaskId,
      this.subtaskIndex,
      this.feeling = ''});

  bool get persisted => id != null;

  String getLastFeeling() {
    return feeling;
  }

  int getFeelingCount() {
    return (feeling.trim() == '') ? 0 : 1;
  }

  void addFeeling(String feeling) {
    this.feeling = feeling;
  }

  String getReadableTime() {
    var seconds = '${time.inSeconds.remainder(60)}'.padLeft(2, '0');
    var minutes = '${time.inMinutes.remainder(60)}'.padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed': completed ? 1 : 0,
      'ancestorTaskId': ancestorTaskId,
      'subtaskIndex': subtaskIndex,
      'feeling': feeling
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(map['name'],
        description: map['description'],
        id: map['id'],
        completed: map['completed'] == 1,
        ancestorTaskId: map['ancestorTaskId'],
        subtaskIndex: map['subtaskIndex'],
        feeling: map['feeling'] ?? '');
  }

  @override
  String toString() {
    return 'Task(id: $id, name: $name)';
  }
}

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
