import '../repositories/food_entry_repository.dart';

class DeleteFoodEntry {
  final FoodEntryRepository repository;

  DeleteFoodEntry(this.repository);

  Future<void> call(String id) async {
    return repository.deleteEntry(id);
  }
}