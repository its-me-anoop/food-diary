import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'database_provider.dart';
import '../models/symptom_model.dart';

abstract class SymptomLocalDataSource {
  Future<List<SymptomModel>> getSymptomsByDate(DateTime date);
  Future<void> insertSymptom(SymptomModel symptom);
  Future<void> updateSymptom(SymptomModel symptom);
  Future<void> deleteSymptom(String id);
  Future<Map<String, int>> symptomFrequency(DateTime start, DateTime end);
}

class SymptomLocalDataSourceImpl implements SymptomLocalDataSource {
  static const _tableName = 'symptoms';

  final DatabaseProvider databaseProvider;

  SymptomLocalDataSourceImpl({required this.databaseProvider});

  Future<Database> get database => databaseProvider.database;

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
    map['potentialTriggerIds'] =
        jsonDecode(data['potentialTriggerIds'] ?? '[]');
    return map;
  }

  @override
  Future<Map<String, int>> symptomFrequency(DateTime start, DateTime end) async {
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
