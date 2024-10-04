import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db!;
    } else {
      return _db!;
    }
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "abd.db");
    Database? database = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return database;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "notes" (id  INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT , 
    note TEXT NOT NULL,
    title TEXT NOT NULL
    )
    ''');
  }

  Future<List<Map<String, Object?>> > readData(String sql) async {
    Database myDatabase = await db;
    List<Map<String, Object?>> response = await myDatabase.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database myDatabase = await db;
    int response = await myDatabase.rawInsert(sql);
    return response;
  }

  deleteData(String sql) async {
    Database myDatabase = await db;
    int response = await myDatabase.rawDelete(sql);
    return response;
  }

  updateData(String sql) async {
    Database myDatabase = await db;
    int response = await myDatabase.rawUpdate(sql);
    return response;
  }
  deleteDtabase1 () async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "abd.db");
    await deleteDatabase(path);
  }
}
