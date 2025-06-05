import 'package:equatable/equatable.dart';
import '../../../domain/entities/food_entry.dart';

abstract class FoodEntryEvent extends Equatable {
  const FoodEntryEvent();

  @override
  List<Object?> get props => [];
}

class LoadEntriesByDate extends FoodEntryEvent {
  final DateTime date;

  const LoadEntriesByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class AddFoodEntryEvent extends FoodEntryEvent {
  final FoodEntry entry;

  const AddFoodEntryEvent(this.entry);

  @override
  List<Object?> get props => [entry];
}

class UpdateFoodEntryEvent extends FoodEntryEvent {
  final FoodEntry entry;

  const UpdateFoodEntryEvent(this.entry);

  @override
  List<Object?> get props => [entry];
}

class DeleteFoodEntryEvent extends FoodEntryEvent {
  final String id;

  const DeleteFoodEntryEvent(this.id);

  @override
  List<Object?> get props => [id];
}