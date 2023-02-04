import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/persistance.dart';

const dbFileName = 'test.db';

Future<AppDatabase> getTestDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return AppDatabase.create(dbName: dbFileName);
}
