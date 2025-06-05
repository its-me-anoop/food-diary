import '../entities/symptom.dart';
import '../repositories/symptom_repository.dart';

class UpdateSymptom {
  final SymptomRepository repository;
  UpdateSymptom(this.repository);

  Future<void> call(Symptom symptom) async {
    return repository.updateSymptom(symptom);
  }
}
