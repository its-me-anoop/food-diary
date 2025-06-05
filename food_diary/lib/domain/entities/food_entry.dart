import 'package:equatable/equatable.dart';

class FoodEntry extends Equatable {
  final String id;
  final String name;
  final List<String> ingredients;
  final DateTime dateTime;
  final String? notes;
  final MealType mealType;
  final List<String> tags; // e.g., "dairy-free", "gluten-free", "contains nuts"

  const FoodEntry({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.dateTime,
    this.notes,
    required this.mealType,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        ingredients,
        dateTime,
        notes,
        mealType,
        tags,
      ];
}

enum MealType { breakfast, lunch, dinner, snack }