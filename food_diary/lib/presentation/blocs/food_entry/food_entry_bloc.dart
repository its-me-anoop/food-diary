import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_food_entry.dart';
import '../../../domain/usecases/delete_food_entry.dart';
import '../../../domain/usecases/get_entries_by_date.dart';
import '../../../domain/usecases/update_food_entry.dart';
import 'food_entry_event.dart';
import 'food_entry_state.dart';

class FoodEntryBloc extends Bloc<FoodEntryEvent, FoodEntryState> {
  final GetEntriesByDate getEntriesByDate;
  final AddFoodEntry addFoodEntry;
  final UpdateFoodEntry updateFoodEntry;
  final DeleteFoodEntry deleteFoodEntry;

  FoodEntryBloc({
    required this.getEntriesByDate,
    required this.addFoodEntry,
    required this.updateFoodEntry,
    required this.deleteFoodEntry,
  }) : super(FoodEntryInitial()) {
    on<LoadEntriesByDate>(_onLoadEntriesByDate);
    on<AddFoodEntryEvent>(_onAddFoodEntry);
    on<UpdateFoodEntryEvent>(_onUpdateFoodEntry);
    on<DeleteFoodEntryEvent>(_onDeleteFoodEntry);
  }

  Future<void> _onLoadEntriesByDate(
    LoadEntriesByDate event,
    Emitter<FoodEntryState> emit,
  ) async {
    emit(FoodEntryLoading());
    try {
      final entries = await getEntriesByDate(event.date);
      emit(FoodEntryLoaded(entries: entries, selectedDate: event.date));
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> _onAddFoodEntry(
    AddFoodEntryEvent event,
    Emitter<FoodEntryState> emit,
  ) async {
    try {
      await addFoodEntry(event.entry);
      if (state is FoodEntryLoaded) {
        final currentState = state as FoodEntryLoaded;
        add(LoadEntriesByDate(currentState.selectedDate));
      }
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> _onUpdateFoodEntry(
    UpdateFoodEntryEvent event,
    Emitter<FoodEntryState> emit,
  ) async {
    try {
      await updateFoodEntry(event.entry);
      if (state is FoodEntryLoaded) {
        final currentState = state as FoodEntryLoaded;
        add(LoadEntriesByDate(currentState.selectedDate));
      }
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }

  Future<void> _onDeleteFoodEntry(
    DeleteFoodEntryEvent event,
    Emitter<FoodEntryState> emit,
  ) async {
    try {
      await deleteFoodEntry(event.id);
      if (state is FoodEntryLoaded) {
        final currentState = state as FoodEntryLoaded;
        add(LoadEntriesByDate(currentState.selectedDate));
      }
    } catch (e) {
      emit(FoodEntryError(e.toString()));
    }
  }
}