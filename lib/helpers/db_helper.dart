import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> getDataBaseInstace() async {
    final db_Path = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(db_Path.toString(), "places.db"),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_paces(id TEXT PRIMARY KEY,title TEXT,image TEXT,loc_lat REAL,loc_lon REAL,address TEXT)",
      );
    }, version: 1);
  }

  static Future<void> insert(String tableName, Map<String, Object> data) async {
    
    final dbInstace= await DBHelper.getDataBaseInstace();
    await dbInstace.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String,dynamic>>> getData(String TableName) async{
    final dbInstace= await DBHelper.getDataBaseInstace();
    return dbInstace.query(TableName);
    
  }
}
