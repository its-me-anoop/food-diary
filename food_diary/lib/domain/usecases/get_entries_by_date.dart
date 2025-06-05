import '../entities/food_entry.dart';
import '../repositories/food_entry_repository.dart';

class GetEntriesByDate {
  final FoodEntryRepository repository;

  GetEntriesByDate(this.repository);

  Future<List<FoodEntry>> call(DateTime date) async {
    return repository.getEntriesByDate(date);
  }
}