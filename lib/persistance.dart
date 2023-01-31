import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'dart:developer' as dev;

class AppDatabase {
  static Database? _database;
  static const dbFileName = 'TODO_APP.db';
  static const tableName = 'tasks';
  static const createTableQuery = 'CREATE TABLE $tableName('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'description TEXT,'
      'completed INTEGER,'
      'subtaskIndex INTEGER,' // defines order of subtasks, NULL if ancestorTaskID is null
      'ancestorTaskId INTEGER,'
      'FOREIGN KEY (ancestorTaskId) REFERENCES $tableName(id))';
  static const databaseVersion = 2;

  Future<Database> getDb() async {
    if (AppDatabase._database != null) {
      return AppDatabase._database!;
    }

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    return openDatabase(join(await getDatabasesPath(), dbFileName),
        onCreate: _onCreate,
        onConfigure: _onConfigure,
        version: databaseVersion);
  }

  void _onCreate(db, version) => db.execute(AppDatabase.createTableQuery);
  void _onConfigure(Database db) => db.execute('PRAGMA foreign_keys = ON;');

  Future<int> insertTask(Task task) async {
    final db = await getDb();
    final id = await db.insert(tableName, task.toMap());
    task.id = id;
    return id;
  }

  Future<void> updateTask(Task task) async {
    final db = await getDb();
    db.update(AppDatabase.tableName, task.toMap(),
        where: 'id=?', whereArgs: [task.id!]);
  }

  Future<List<Task>> tasks() async {
    final db = await getDb();
    List<Map<String, dynamic>> tasks = await db.query(tableName);
    dev.log('Fetched ${tasks.length} task(s) from the DB');
    return List.generate(tasks.length, (index) => Task.fromMap(tasks[index]));
  }
}
