// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as dev;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

const dbFileName = 'TODO_APP.db';

class AppDatabase {
  static const createTableQuery = 'CREATE TABLE $tableName('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'description TEXT,'
      'completed INTEGER,'
      'subtaskIndex INTEGER,' // defines order of subtasks, NULL if ancestorTaskID is null
      'ancestorTaskId INTEGER,'
      'feeling TEXT,'
      'FOREIGN KEY (ancestorTaskId) REFERENCES $tableName(id))';
  static const tableName = 'tasks';

  static const databaseVersion = 2;
  static AppDatabase? _instance;

  late Database _db;
  String dbName;

  AppDatabase(this.dbName);

  Database get database => _db;

  static Future<AppDatabase> create(
      {String dbName = dbFileName,
      Future<Database> Function()? dbGenerator}) async {
    if (_instance == null) {
      _instance = AppDatabase(dbName);
      dbGenerator ??= _instance!._initDb;
      _instance!._db = await dbGenerator();
    }

    return _instance!;
  }

  Future<void> initCustomDb(Function(Database) openDb) async {}

  Future<Database> _initDb() async {
    return openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: _onCreate,
        onConfigure: _onConfigure,
        version: databaseVersion);
  }

  Future<void> deleteAppDatabase() async {
    await deleteDatabase(join(await getDatabasesPath(), dbName));
  }

  void _onCreate(db, version) => db.execute(createTableQuery);
  void _onConfigure(Database db) => db.execute('PRAGMA foreign_keys = ON;');

  Future<int> insertTask(Task task) async {
    final id = await _db.insert(tableName, task.toMap());
    task.id = id;
    return id;
  }

  Future<void> updateTask(Task task) async {
    dev.log('Updating task with id ${task.id}');
    _db.update(tableName, task.toMap(), where: 'id=?', whereArgs: [task.id!]);
  }

  Future<List<Task>> fetchSutasks(Task task) async {
    final List<Map<String, dynamic>> tasks = await _db
        .query(tableName, where: 'ancestorTaskId=?', whereArgs: [task.id]);
    return databaseResultToTaskList(tasks);
  }

  Future<List<Task>> tasks() async {
    final List<Map<String, dynamic>> tasks = await _db.query(tableName);
    dev.log('Fetched ${tasks.length} task(s) from the DB');
    return databaseResultToTaskList(tasks);
  }

  static List<Task> databaseResultToTaskList(List<Map<String, dynamic>> tasks) {
    return List.generate(tasks.length, (index) => Task.fromMap(tasks[index]));
  }

  Future<void> close() async {
    await database.close();
    _instance = null;
  }
}
