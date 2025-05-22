import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._constructor();
  LocalDatabase._constructor();

  static const _dbName = 'expressErp.db';
  static const _dbVersion = 2;

  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String directory = await getDatabasesPath();
    String path = join(directory, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE userInfo (
      id               INTEGER PRIMARY KEY AUTOINCREMENT,
      userId          TEXT NOT NULL,
      userName        TEXT NOT NULL,
      mobileNo        TEXT NOT NULL,
      userDesg        TEXT NOT NULL,
      userDept       TEXT NOT NULL
      )
      ''');
        await db.execute('''
      CREATE TABLE company (
      id               INTEGER PRIMARY KEY AUTOINCREMENT,
      baseUrl          TEXT NOT NULL,
      comName          TEXT NOT NULL
      )
      ''');
      },
      onConfigure: (db) {},
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('''
      CREATE TABLE company (
      id               INTEGER PRIMARY KEY AUTOINCREMENT,
      baseUrl          TEXT NOT NULL,
      comName          TEXT NOT NULL
      )
      ''');
        }
      },
    );
  }
}
