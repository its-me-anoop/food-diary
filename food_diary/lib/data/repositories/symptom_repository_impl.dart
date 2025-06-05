import '../../domain/entities/symptom.dart';
import '../../domain/repositories/symptom_repository.dart';
import '../datasources/symptom_local_datasource.dart';
import '../models/symptom_model.dart';

class SymptomRepositoryImpl implements SymptomRepository {
  final SymptomLocalDataSource localDataSource;

  SymptomRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addSymptom(Symptom symptom) async {
    final model = SymptomModel.fromEntity(symptom);
    await localDataSource.insertSymptom(model);
  }

  @override
  Future<void> deleteSymptom(String id) async {
    await localDataSource.deleteSymptom(id);
  }

  @override
  Future<List<Symptom>> getSymptomsByDate(DateTime date) async {
    return localDataSource.getSymptomsByDate(date);
  }

  @override
  Future<void> updateSymptom(Symptom symptom) async {
    final model = SymptomModel.fromEntity(symptom);
    await localDataSource.updateSymptom(model);
  }

  @override
  Future<List<Symptom>> getAllSymptoms() async {
    return localDataSource.getAllSymptoms();
  }

  @override
  Future<Symptom?> getSymptomById(String id) async {
    final list = await localDataSource.getSymptomsByDate(DateTime.now());
    for (final symptom in list) {
      if (symptom.id == id) return symptom;
    }
    return null;
  }

  @override
  Future<List<Symptom>> getSymptomsBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    // not implemented: gather by frequency
    final freq = await localDataSource.getSymptomsByDate(start);
    return freq; // placeholder
  }

  @override
  Future<Map<String, int>> getSymptomFrequency(
    DateTime start,
    DateTime end,
  ) async {
    return localDataSource.symptomFrequency(start, end);
  }
}
