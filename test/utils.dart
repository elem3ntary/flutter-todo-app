import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/persistance.dart';

const dbFileName = 'test.db';

Future<AppDatabase> getTestDatabase() async {
  if (!Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  }

  return AppDatabase.create(
      dbName: dbFileName,
      dbGenerator: () async {
        return openDatabase(join(await getDatabasesPath(), dbFileName),
            onCreate: ((db, version) =>
                db.execute(AppDatabase.createTableQuery)),
            version: AppDatabase.databaseVersion);
      });
}
