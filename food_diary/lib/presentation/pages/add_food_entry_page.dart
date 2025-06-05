import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/food_entry.dart';
import '../blocs/food_entry/food_entry_bloc.dart';
import '../blocs/food_entry/food_entry_event.dart';
import '../theme/app_theme.dart';

class AddFoodEntryPage extends StatefulWidget {
  final DateTime selectedDate;
  final FoodEntry? entryToEdit;

  const AddFoodEntryPage({
    super.key,
    required this.selectedDate,
    this.entryToEdit,
  });

  @override
  State<AddFoodEntryPage> createState() => _AddFoodEntryPageState();
}

class _AddFoodEntryPageState extends State<AddFoodEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _notesController = TextEditingController();
  
  late MealType _selectedMealType;
  late DateTime _selectedDateTime;
  List<String> _ingredients = [];
  List<String> _tags = [];
  
  final List<String> _commonTags = [
    'Contains dairy',
    'Contains gluten',
    'Contains nuts',
    'Contains eggs',
    'Contains soy',
    'Contains shellfish',
    'Dairy-free',
    'Gluten-free',
    'Nut-free',
    'Vegan',
    'Vegetarian',
    'Spicy',
    'Home-cooked',
    'Restaurant',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDate;
    _selectedMealType = MealType.breakfast;
    
    if (widget.entryToEdit != null) {
      final entry = widget.entryToEdit!;
      _nameController.text = entry.name;
      _ingredients = List.from(entry.ingredients);
      _tags = List.from(entry.tags);
      _notesController.text = entry.notes ?? '';
      _selectedMealType = entry.mealType;
      _selectedDateTime = entry.dateTime;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.entryToEdit == null ? 'Add Meal' : 'Edit Meal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildFoodNameField(),
            const SizedBox(height: 24.0),
            _buildMealTypeSelector(),
            const SizedBox(height: 24.0),
            _buildIngredientsSection(),
            const SizedBox(height: 24.0),
            _buildTagsSection(),
            const SizedBox(height: 24.0),
            _buildNotesField(),
            const SizedBox(height: 32.0),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What did you eat?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'e.g., Chicken Caesar Salad',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a food name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meal Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: MealType.values.map((mealType) {
            final isSelected = _selectedMealType == mealType;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMealType = mealType;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getMealTypeIcon(mealType),
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getMealTypeName(mealType),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ingredientController,
                decoration: const InputDecoration(
                  hintText: 'Add an ingredient',
                ),
                onFieldSubmitted: _addIngredient,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _addIngredient(_ingredientController.text),
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_ingredients.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ingredients.map((ingredient) {
              return Chip(
                label: Text(ingredient),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    _ingredients.remove(ingredient);
                  });
                },
                backgroundColor: Colors.grey.shade100,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags & Allergens',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonTags.map((tag) {
            final isSelected = _tags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _tags.add(tag);
                  } else {
                    _tags.remove(tag);
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: tag.toLowerCase().contains('contains')
                  ? AppTheme.warningColor.withValues(alpha: 0.2)
                  : AppTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: tag.toLowerCase().contains('contains')
                  ? AppTheme.warningColor
                  : AppTheme.primaryColor,
              side: BorderSide(
                color: isSelected
                    ? (tag.toLowerCase().contains('contains')
                        ? AppTheme.warningColor
                        : AppTheme.primaryColor)
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Any additional details...',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveEntry,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        widget.entryToEdit == null ? 'Add Meal' : 'Update Meal',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  IconData _getMealTypeIcon(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.wb_sunny;
      case MealType.lunch:
        return Icons.wb_sunny_outlined;
      case MealType.dinner:
        return Icons.nightlight_round;
      case MealType.snack:
        return Icons.cookie;
    }
  }

  String _getMealTypeName(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one ingredient'),
          ),
        );
        return;
      }

      final entry = FoodEntry(
        id: widget.entryToEdit?.id ?? const Uuid().v4(),
        name: _nameController.text,
        ingredients: _ingredients,
        dateTime: _selectedDateTime,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        mealType: _selectedMealType,
        tags: _tags,
      );

      if (widget.entryToEdit == null) {
        context.read<FoodEntryBloc>().add(AddFoodEntryEvent(entry));
      } else {
        context.read<FoodEntryBloc>().add(UpdateFoodEntryEvent(entry));
      }

      Navigator.of(context).pop();
    }
  }
}