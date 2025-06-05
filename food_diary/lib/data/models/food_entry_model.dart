import '../../domain/entities/food_entry.dart';

class FoodEntryModel extends FoodEntry {
  const FoodEntryModel({
    required super.id,
    required super.name,
    required super.ingredients,
    required super.dateTime,
    super.notes,
    required super.mealType,
    required super.tags,
  });

  factory FoodEntryModel.fromEntity(FoodEntry entity) {
    return FoodEntryModel(
      id: entity.id,
      name: entity.name,
      ingredients: entity.ingredients,
      dateTime: entity.dateTime,
      notes: entity.notes,
      mealType: entity.mealType,
      tags: entity.tags,
    );
  }

  factory FoodEntryModel.fromJson(Map<String, dynamic> json) {
    return FoodEntryModel(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      dateTime: DateTime.parse(json['dateTime']),
      notes: json['notes'],
      mealType: MealType.values[json['mealType']],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
      'mealType': mealType.index,
      'tags': tags,
    };
  }
}