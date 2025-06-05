import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/symptom_model.dart';

abstract class SymptomLocalDataSource {
  Future<List<SymptomModel>> getSymptomsByDate(DateTime date);
  Future<List<SymptomModel>> getSymptomsBetweenDates(
    DateTime start,
    DateTime end,
  );
  Future<void> insertSymptom(SymptomModel symptom);
  Future<void> updateSymptom(SymptomModel symptom);
  Future<void> deleteSymptom(String id);
  Future<Map<String, int>> symptomFrequency(DateTime start, DateTime end);
}

class SymptomLocalDataSourceImpl implements SymptomLocalDataSource {
  static const _dbName = 'food_diary.db';
  static const _tableName = 'symptoms';
  static const _version = 2;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        severity INTEGER NOT NULL,
        occurredAt TEXT NOT NULL,
        notes TEXT,
        potentialTriggerIds TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Recreate the table for the new schema. The previous implementation
      // attempted to call `_onCreate` directly which would fail if the table
      // already existed. Dropping the old table first avoids the "table already
      // exists" error when migrating from older versions.
      await db.execute('DROP TABLE IF EXISTS $_tableName');
      await _onCreate(db, newVersion);
    }
  }

  @override
  Future<List<SymptomModel>> getSymptomsByDate(DateTime date) async {
    final db = await database;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final maps = await db.query(
      _tableName,
      where: 'occurredAt >= ? AND occurredAt < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return maps.map((e) => SymptomModel.fromJson(_deserialize(e))).toList();
  }

  @override
  Future<List<SymptomModel>> getSymptomsBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'occurredAt >= ? AND occurredAt <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return maps.map((e) => SymptomModel.fromJson(_deserialize(e))).toList();
  }

  @override
  Future<void> insertSymptom(SymptomModel symptom) async {
    final db = await database;
    await db.insert(
      _tableName,
      _serialize(symptom.toJson()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateSymptom(SymptomModel symptom) async {
    final db = await database;
    await db.update(
      _tableName,
      _serialize(symptom.toJson()),
      where: 'id = ?',
      whereArgs: [symptom.id],
    );
  }

  @override
  Future<void> deleteSymptom(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _serialize(Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data);
    map['potentialTriggerIds'] = jsonEncode(data['potentialTriggerIds'] ?? []);
    return map;
  }

  Map<String, dynamic> _deserialize(Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data);
    map['potentialTriggerIds'] = jsonDecode(
      data['potentialTriggerIds'] ?? '[]',
    );
    return map;
  }

  @override
  Future<Map<String, int>> symptomFrequency(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      columns: ['name', 'COUNT(*) as count'],
      where: 'occurredAt >= ? AND occurredAt <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      groupBy: 'name',
    );
    return {for (final m in maps) m['name'] as String: m['count'] as int};
  }
}
