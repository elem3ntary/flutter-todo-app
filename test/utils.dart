import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/persistance.dart';

const dbFileName = 'test.db';

Future<Database> getTestDatabase() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return AppDatabase().getDb(dbFileName: dbFileName);
}

Future<void> deleteMockDb() async {
  await AppDatabase.deleteAppDatabase(dbFileName);
}
