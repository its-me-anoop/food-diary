import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_entry_model.dart';

abstract class FoodEntryLocalDataSource {
  Future<List<FoodEntryModel>> getAllEntries();
  Future<List<FoodEntryModel>> getEntriesByDate(DateTime date);
  Future<FoodEntryModel?> getEntryById(String id);
  Future<void> insertEntry(FoodEntryModel entry);
  Future<void> updateEntry(FoodEntryModel entry);
  Future<void> deleteEntry(String id);
  Future<List<FoodEntryModel>> getEntriesBetweenDates(DateTime start, DateTime end);
}

class FoodEntryLocalDataSourceImpl implements FoodEntryLocalDataSource {
  static const String _databaseName = 'food_diary.db';
  static const String _tableName = 'food_entries';
  static const int _databaseVersion = 2;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        notes TEXT,
        mealType INTEGER NOT NULL,
        tags TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration from version 1 to 2
      // Create a new table with the new schema
      await db.execute('''
        CREATE TABLE ${_tableName}_new (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          ingredients TEXT NOT NULL,
          dateTime TEXT NOT NULL,
          notes TEXT,
          mealType INTEGER NOT NULL,
          tags TEXT NOT NULL
        )
      ''');
      
      // Copy data from old table to new table with default values for new columns
      await db.execute('''
        INSERT INTO ${_tableName}_new (id, name, ingredients, dateTime, notes, mealType, tags)
        SELECT id, name, '[]', dateTime, notes, mealType, '[]'
        FROM $_tableName
      ''');
      
      // Drop the old table
      await db.execute('DROP TABLE $_tableName');
      
      // Rename the new table to the original name
      await db.execute('ALTER TABLE ${_tableName}_new RENAME TO $_tableName');
    }
  }

  @override
  Future<List<FoodEntryModel>> getAllEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return FoodEntryModel.fromJson(_deserializeEntry(maps[i]));
    });
  }

  @override
  Future<List<FoodEntryModel>> getEntriesByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'dateTime >= ? AND dateTime < ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
    );
    
    return List.generate(maps.length, (i) {
      return FoodEntryModel.fromJson(_deserializeEntry(maps[i]));
    });
  }

  @override
  Future<FoodEntryModel?> getEntryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return FoodEntryModel.fromJson(_deserializeEntry(maps.first));
    }
    return null;
  }

  @override
  Future<void> insertEntry(FoodEntryModel entry) async {
    final db = await database;
    await db.insert(
      _tableName,
      _serializeEntry(entry.toJson()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateEntry(FoodEntryModel entry) async {
    final db = await database;
    await db.update(
      _tableName,
      _serializeEntry(entry.toJson()),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<FoodEntryModel>> getEntriesBetweenDates(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'dateTime >= ? AND dateTime <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    
    return List.generate(maps.length, (i) {
      return FoodEntryModel.fromJson(_deserializeEntry(maps[i]));
    });
  }

  // Helper method to serialize entry for database storage
  Map<String, dynamic> _serializeEntry(Map<String, dynamic> entry) {
    final serialized = Map<String, dynamic>.from(entry);
    // Convert lists to JSON strings for storage
    serialized['ingredients'] = jsonEncode(entry['ingredients'] ?? []);
    serialized['tags'] = jsonEncode(entry['tags'] ?? []);
    return serialized;
  }

  // Helper method to deserialize entry from database
  Map<String, dynamic> _deserializeEntry(Map<String, dynamic> entry) {
    final deserialized = Map<String, dynamic>.from(entry);
    // Convert JSON strings back to lists
    deserialized['ingredients'] = jsonDecode(entry['ingredients'] ?? '[]');
    deserialized['tags'] = jsonDecode(entry['tags'] ?? '[]');
    return deserialized;
  }
}