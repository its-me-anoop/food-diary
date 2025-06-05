import '../entities/symptom.dart';

abstract class SymptomRepository {
  Future<List<Symptom>> getAllSymptoms();
  Future<List<Symptom>> getSymptomsByDate(DateTime date);
  Future<Symptom?> getSymptomById(String id);
  Future<void> addSymptom(Symptom symptom);
  Future<void> updateSymptom(Symptom symptom);
  Future<void> deleteSymptom(String id);
  Future<List<Symptom>> getSymptomsBetweenDates(DateTime start, DateTime end);
  Future<Map<String, int>> getSymptomFrequency(DateTime start, DateTime end);
}