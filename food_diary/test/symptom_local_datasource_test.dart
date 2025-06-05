import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:food_diary/data/datasources/symptom_local_datasource.dart';
import 'package:food_diary/domain/entities/symptom.dart';
import 'package:food_diary/data/models/symptom_model.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late SymptomLocalDataSource dataSource;

  setUp(() {
    dataSource = SymptomLocalDataSourceImpl();
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

  test('get all symptoms returns every stored symptom', () async {
    final symptom1 = SymptomModel(
      id: '1',
      name: 'One',
      severity: SeverityLevel.mild,
      occurredAt: DateTime.now(),
      potentialTriggerIds: const [],
    );
    final symptom2 = SymptomModel(
      id: '2',
      name: 'Two',
      severity: SeverityLevel.moderate,
      occurredAt: DateTime.now().add(const Duration(days: 1)),
      potentialTriggerIds: const [],
    );

    await dataSource.insertSymptom(symptom1);
    await dataSource.insertSymptom(symptom2);

    final all = await dataSource.getAllSymptoms();
    expect(all.length, 2);
    expect(all.map((e) => e.id).toSet(), {'1', '2'});
  });
}
