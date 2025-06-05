import '../entities/food_entry.dart';
import '../repositories/food_entry_repository.dart';

class UpdateFoodEntry {
  final FoodEntryRepository repository;

  UpdateFoodEntry(this.repository);

  Future<void> call(FoodEntry entry) async {
    return repository.updateEntry(entry);
  }
}