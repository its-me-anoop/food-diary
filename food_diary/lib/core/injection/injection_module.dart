import 'package:injectable/injectable.dart';
import '../../data/datasources/food_entry_local_datasource.dart';
import '../../data/repositories/food_entry_repository_impl.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/usecases/add_food_entry.dart';
import '../../domain/usecases/delete_food_entry.dart';
import '../../domain/usecases/get_entries_by_date.dart';
import '../../domain/usecases/update_food_entry.dart';
import '../../data/datasources/symptom_local_datasource.dart';
import '../../data/repositories/symptom_repository_impl.dart';
import '../../domain/repositories/symptom_repository.dart';
import '../../domain/usecases/add_symptom.dart';
import '../../domain/usecases/update_symptom.dart';
import '../../domain/usecases/delete_symptom.dart';
import '../../domain/usecases/get_symptoms_by_date.dart';
import '../../domain/usecases/get_symptom_frequency.dart';

@module
abstract class InjectionModule {
  @lazySingleton
  FoodEntryLocalDataSource get foodEntryLocalDataSource => FoodEntryLocalDataSourceImpl();

  @lazySingleton
  FoodEntryRepository get foodEntryRepository => FoodEntryRepositoryImpl(
        localDataSource: foodEntryLocalDataSource,
      );

  @lazySingleton
  GetEntriesByDate get getEntriesByDate => GetEntriesByDate(foodEntryRepository);

  @lazySingleton
  AddFoodEntry get addFoodEntry => AddFoodEntry(foodEntryRepository);

  @lazySingleton
  UpdateFoodEntry get updateFoodEntry => UpdateFoodEntry(foodEntryRepository);

  @lazySingleton
  DeleteFoodEntry get deleteFoodEntry => DeleteFoodEntry(foodEntryRepository);

  @lazySingleton
  SymptomLocalDataSource get symptomLocalDataSource => SymptomLocalDataSourceImpl();

  @lazySingleton
  SymptomRepository get symptomRepository => SymptomRepositoryImpl(
        localDataSource: symptomLocalDataSource,
      );

  @lazySingleton
  GetSymptomsByDate get getSymptomsByDate => GetSymptomsByDate(symptomRepository);

  @lazySingleton
  AddSymptom get addSymptom => AddSymptom(symptomRepository);

  @lazySingleton
  UpdateSymptom get updateSymptom => UpdateSymptom(symptomRepository);

  @lazySingleton
  DeleteSymptom get deleteSymptom => DeleteSymptom(symptomRepository);

  @lazySingleton
  GetSymptomFrequency get getSymptomFrequency => GetSymptomFrequency(symptomRepository);
}