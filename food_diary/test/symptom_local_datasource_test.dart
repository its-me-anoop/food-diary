import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:food_diary/data/datasources/database_provider.dart';
import 'package:food_diary/data/datasources/symptom_local_datasource.dart';
import 'package:food_diary/domain/entities/symptom.dart';
import 'package:food_diary/data/models/symptom_model.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late SymptomLocalDataSource dataSource;

  setUp(() async {
    await DatabaseProvider.instance.database;
    dataSource = SymptomLocalDataSourceImpl(
      databaseProvider: DatabaseProvider.instance,
    );
  });

  test('insert and retrieve symptom', () async {
    final symptom = SymptomModel(
      id: '1',
      name: 'Test',
      severity: SeverityLevel.mild,
      occurredAt: DateTime.now(),
      notes: 'note',
      potentialTriggerIds: const [],
    );

    await dataSource.insertSymptom(symptom);
    final result = await dataSource.getSymptomsByDate(DateTime.now());
    expect(result.first.name, 'Test');
  });

  test('retrieve symptoms between dates', () async {
    final base = DateTime(2024, 1, 1, 12);
    final symptoms = [
      SymptomModel(
        id: '1',
        name: 'Prev',
        severity: SeverityLevel.mild,
        occurredAt: base.subtract(const Duration(days: 1)),
        potentialTriggerIds: const [],
      ),
      SymptomModel(
        id: '2',
        name: 'Base',
        severity: SeverityLevel.moderate,
        occurredAt: base,
        potentialTriggerIds: const [],
      ),
      SymptomModel(
        id: '3',
        name: 'Next',
        severity: SeverityLevel.severe,
        occurredAt: base.add(const Duration(days: 1)),
        potentialTriggerIds: const [],
      ),
      SymptomModel(
        id: '4',
        name: 'Out',
        severity: SeverityLevel.mild,
        occurredAt: base.add(const Duration(days: 2)),
        potentialTriggerIds: const [],
      ),
    ];

    for (final s in symptoms) {
      await dataSource.insertSymptom(s);
    }

    final result = await dataSource.getSymptomsBetweenDates(
      base.subtract(const Duration(days: 1)),
      base.add(const Duration(days: 1)),
    );

    expect(result.length, 3);
    final ids = result.map((e) => e.id);
    expect(ids, contains('1'));
    expect(ids, contains('2'));
    expect(ids, contains('3'));
    expect(ids, isNot(contains('4')));
  });
}
