import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<void> insert(String tableName, Map<String, Object> data) async {
    final db_Path = await sql.getDatabasesPath();
    final sqlDB_created = await sql.openDatabase(
        path.join(db_Path.toString(), "places.db"), onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_paces(id TEXT PRIMARY KEY,title TEXT,image TEXT,)",
      );
    }, version: 1);

    await  sqlDB_created.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
