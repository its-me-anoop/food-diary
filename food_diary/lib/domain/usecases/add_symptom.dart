import '../entities/symptom.dart';
import '../repositories/symptom_repository.dart';

class AddSymptom {
  final SymptomRepository repository;
  AddSymptom(this.repository);

  Future<void> call(Symptom symptom) async {
    return repository.addSymptom(symptom);
  }
}
