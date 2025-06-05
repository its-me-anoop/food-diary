import '../repositories/symptom_repository.dart';

class DeleteSymptom {
  final SymptomRepository repository;
  DeleteSymptom(this.repository);

  Future<void> call(String id) async {
    return repository.deleteSymptom(id);
  }
}
