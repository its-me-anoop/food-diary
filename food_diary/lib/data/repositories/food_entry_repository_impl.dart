import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../datasources/food_entry_local_datasource.dart';
import '../models/food_entry_model.dart';

class FoodEntryRepositoryImpl implements FoodEntryRepository {
  final FoodEntryLocalDataSource localDataSource;

  FoodEntryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FoodEntry>> getAllEntries() async {
    final entries = await localDataSource.getAllEntries();
    return entries;
  }

  @override
  Future<List<FoodEntry>> getEntriesByDate(DateTime date) async {
    final entries = await localDataSource.getEntriesByDate(date);
    return entries;
  }

  @override
  Future<FoodEntry?> getEntryById(String id) async {
    final entry = await localDataSource.getEntryById(id);
    return entry;
  }

  @override
  Future<void> addEntry(FoodEntry entry) async {
    final entryModel = FoodEntryModel.fromEntity(entry);
    await localDataSource.insertEntry(entryModel);
  }

  @override
  Future<void> updateEntry(FoodEntry entry) async {
    final entryModel = FoodEntryModel.fromEntity(entry);
    await localDataSource.updateEntry(entryModel);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await localDataSource.deleteEntry(id);
  }

  @override
  Future<List<FoodEntry>> getEntriesBetweenDates(DateTime start, DateTime end) async {
    final entries = await localDataSource.getEntriesBetweenDates(start, end);
    return entries;
  }
}