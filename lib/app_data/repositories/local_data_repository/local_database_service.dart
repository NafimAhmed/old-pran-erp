import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._constructor();
  LocalDatabase._constructor();

  static const _dbName = 'expressErp.db';
  static const _dbVersion = 1;

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
      CREATE TABLE user (
      id               INTEGER PRIMARY KEY AUTOINCREMENT,
      staffId          INTEGER NOT NULL,
      userName        TEXT NOT NULL
      )
      ''');
      },
      onConfigure: (db) {},
    );
  }
}
