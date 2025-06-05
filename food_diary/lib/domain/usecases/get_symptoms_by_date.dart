import '../entities/symptom.dart';
import '../repositories/symptom_repository.dart';

class GetSymptomsByDate {
  final SymptomRepository repository;
  GetSymptomsByDate(this.repository);

  Future<List<Symptom>> call(DateTime date) async {
    return repository.getSymptomsByDate(date);
  }
}
