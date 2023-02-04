// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as dev;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

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
      'feeling TEXT,'
      'FOREIGN KEY (ancestorTaskId) REFERENCES $tableName(id))';
  static const databaseVersion = 2;

  static void setDb(Database database) {
    AppDatabase._database = database;
  }

  Future<Database> getDb({String dbFileName = AppDatabase.dbFileName}) async {
    if (AppDatabase._database != null) {
      return AppDatabase._database!;
    }

    _database = await _initDb(dbFileName);
    return _database!;
  }

  Future<Database> _initDb(String dbFileName) async {
    return openDatabase(join(await getDatabasesPath(), dbFileName),
        onCreate: _onCreate,
        onConfigure: _onConfigure,
        version: databaseVersion);
  }

  static Future<void> deleteAppDatabase(String dbFileName) async {
    await deleteDatabase(join(await getDatabasesPath(), dbFileName));
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
    dev.log('Updating task with id ${task.id}');
    db.update(AppDatabase.tableName, task.toMap(),
        where: 'id=?', whereArgs: [task.id!]);
  }

  Future<List<Task>> fetchSutasks(Task task) async {
    final db = await getDb();
    final List<Map<String, dynamic>> tasks = await db
        .query(tableName, where: 'ancestorTaskId=?', whereArgs: [task.id]);
    return databaseResultToTaskList(tasks);
  }

  Future<List<Task>> tasks() async {
    final db = await getDb();
    final List<Map<String, dynamic>> tasks = await db.query(tableName);
    dev.log('Fetched ${tasks.length} task(s) from the DB');
    return databaseResultToTaskList(tasks);
  }

  List<Task> databaseResultToTaskList(List<Map<String, dynamic>> tasks) {
    return List.generate(tasks.length, (index) => Task.fromMap(tasks[index]));
  }
}
