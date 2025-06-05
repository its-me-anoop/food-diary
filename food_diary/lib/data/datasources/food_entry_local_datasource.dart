import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';
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
  static const String _tableName = 'food_entries';

  final DatabaseProvider databaseProvider;

  FoodEntryLocalDataSourceImpl({required this.databaseProvider});

  Future<Database> get database => databaseProvider.database;

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