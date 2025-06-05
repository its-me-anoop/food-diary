import '../entities/food_entry.dart';
import '../repositories/food_entry_repository.dart';

class AddFoodEntry {
  final FoodEntryRepository repository;

  AddFoodEntry(this.repository);

  Future<void> call(FoodEntry entry) async {
    return repository.addEntry(entry);
  }
}