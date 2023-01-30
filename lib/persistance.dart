import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/task.dart';

class AppDatabase {
  static Database? _instance;
  static const dbFileName = 'TODO_APP.db';
  static const tableName = 'tasks';
  static const createTableQuery =
      'CREATE TABLE ${AppDatabase.tableName}(id INTEGER PRIMARY KEY, name TEXT, description TEXT, completed INTEGER';

  static Future<Database> getDb() async {
    if (AppDatabase._instance != null) {
      return AppDatabase._instance!;
    }

    _instance = await _initDb();
    return _instance!;
  }

  static Future<Database> _initDb() async {
    return openDatabase(join(await getDatabasesPath(), AppDatabase.dbFileName),
        onCreate: ((db, version) => db.execute(AppDatabase.createTableQuery)),
        version: 1);
  }

  static Future<void> insertTask(Task task) async {
    final db = await getDb();
    final id = await db.insert(tableName, task.toMap());
    task.id = id;
  }

  static Future<List<Task>> tasks() async {
    final db = await AppDatabase.getDb();
    List<Map<String, dynamic>> tasks = await db.query(tableName);
    return List.generate(
        tasks.length,
        (index) => Task(
              tasks[index]['name'],
              description: tasks[index]['description'],
              id: tasks[index]['id'],
              completed: tasks[index]['completed'],
            ));
  }
}
