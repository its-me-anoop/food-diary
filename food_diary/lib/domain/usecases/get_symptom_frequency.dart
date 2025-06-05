import '../repositories/symptom_repository.dart';

class GetSymptomFrequency {
  final SymptomRepository repository;
  GetSymptomFrequency(this.repository);

  Future<Map<String, int>> call(DateTime start, DateTime end) async {
    return repository.getSymptomFrequency(start, end);
  }
}
