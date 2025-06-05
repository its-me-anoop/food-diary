import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._internal();

  static const _databaseName = 'food_diary.db';
  static const _databaseVersion = 2;

  Database? _database;

  DatabaseProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), _databaseName);
    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_entries (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        notes TEXT,
        mealType INTEGER NOT NULL,
        tags TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE symptoms(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        severity INTEGER NOT NULL,
        occurredAt TEXT NOT NULL,
        notes TEXT,
        potentialTriggerIds TEXT NOT NULL
      )
    ''');
  }
}
