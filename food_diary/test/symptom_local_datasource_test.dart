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
}
