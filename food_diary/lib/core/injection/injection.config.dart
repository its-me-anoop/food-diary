// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:food_diary/core/injection/injection_module.dart' as _i1023;
import 'package:food_diary/data/datasources/food_entry_local_datasource.dart'
    as _i119;
import 'package:food_diary/domain/repositories/food_entry_repository.dart'
    as _i484;
import 'package:food_diary/domain/usecases/add_food_entry.dart' as _i67;
import 'package:food_diary/domain/usecases/delete_food_entry.dart' as _i723;
import 'package:food_diary/domain/usecases/get_entries_by_date.dart' as _i758;
import 'package:food_diary/domain/usecases/update_food_entry.dart' as _i189;
import 'package:food_diary/data/datasources/symptom_local_datasource.dart' as _i200;
import 'package:food_diary/domain/repositories/symptom_repository.dart' as _i201;
import 'package:food_diary/domain/usecases/add_symptom.dart' as _i202;
import 'package:food_diary/domain/usecases/update_symptom.dart' as _i203;
import 'package:food_diary/domain/usecases/delete_symptom.dart' as _i204;
import 'package:food_diary/domain/usecases/get_symptoms_by_date.dart' as _i205;
import 'package:food_diary/domain/usecases/get_symptom_frequency.dart' as _i206;
import 'package:food_diary/data/repositories/symptom_repository_impl.dart' as _i207;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    gh.lazySingleton<_i119.FoodEntryLocalDataSource>(
      () => injectionModule.foodEntryLocalDataSource,
    );
    gh.lazySingleton<_i484.FoodEntryRepository>(
      () => injectionModule.foodEntryRepository,
    );
    gh.lazySingleton<_i758.GetEntriesByDate>(
      () => injectionModule.getEntriesByDate,
    );
    gh.lazySingleton<_i67.AddFoodEntry>(() => injectionModule.addFoodEntry);
    gh.lazySingleton<_i189.UpdateFoodEntry>(
      () => injectionModule.updateFoodEntry,
    );
    gh.lazySingleton<_i723.DeleteFoodEntry>(
      () => injectionModule.deleteFoodEntry,
    );
    gh.lazySingleton<_i200.SymptomLocalDataSource>(
      () => injectionModule.symptomLocalDataSource,
    );
    gh.lazySingleton<_i201.SymptomRepository>(
      () => injectionModule.symptomRepository,
    );
    gh.lazySingleton<_i205.GetSymptomsByDate>(
      () => injectionModule.getSymptomsByDate,
    );
    gh.lazySingleton<_i202.AddSymptom>(
      () => injectionModule.addSymptom,
    );
    gh.lazySingleton<_i203.UpdateSymptom>(
      () => injectionModule.updateSymptom,
    );
    gh.lazySingleton<_i204.DeleteSymptom>(
      () => injectionModule.deleteSymptom,
    );
    gh.lazySingleton<_i206.GetSymptomFrequency>(
      () => injectionModule.getSymptomFrequency,
    );
    return this;
  }
}

class _$InjectionModule extends _i1023.InjectionModule {}
