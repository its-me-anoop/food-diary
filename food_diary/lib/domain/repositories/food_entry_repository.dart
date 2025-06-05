import '../entities/food_entry.dart';

abstract class FoodEntryRepository {
  Future<List<FoodEntry>> getAllEntries();
  Future<List<FoodEntry>> getEntriesByDate(DateTime date);
  Future<FoodEntry?> getEntryById(String id);
  Future<void> addEntry(FoodEntry entry);
  Future<void> updateEntry(FoodEntry entry);
  Future<void> deleteEntry(String id);
  Future<List<FoodEntry>> getEntriesBetweenDates(DateTime start, DateTime end);
}