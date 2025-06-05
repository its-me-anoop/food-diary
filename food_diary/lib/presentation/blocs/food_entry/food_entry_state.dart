import 'package:equatable/equatable.dart';
import '../../../domain/entities/food_entry.dart';

abstract class FoodEntryState extends Equatable {
  const FoodEntryState();

  @override
  List<Object?> get props => [];
}

class FoodEntryInitial extends FoodEntryState {}

class FoodEntryLoading extends FoodEntryState {}

class FoodEntryLoaded extends FoodEntryState {
  final List<FoodEntry> entries;
  final DateTime selectedDate;

  const FoodEntryLoaded({
    required this.entries,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [entries, selectedDate];
}

class FoodEntryError extends FoodEntryState {
  final String message;

  const FoodEntryError(this.message);

  @override
  List<Object?> get props => [message];
}