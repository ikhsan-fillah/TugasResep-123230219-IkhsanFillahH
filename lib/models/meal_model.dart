import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  final String idMeal;

  @HiveField(1)
  final String strMeal;

  @HiveField(2)
  final String strMealThumb;

  @HiveField(3)
  String? strCategory;

  @HiveField(4)
  String? strArea;

  @HiveField(5)
  String? strInstructions;

  @HiveField(6)
  List<String>? ingredients;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingList = [];
    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        final m = measure != null ? measure.toString().trim() : '';
        ingList.add(m.isNotEmpty ? '$m ${ing.toString().trim()}' : ing.toString().trim());
      }
    }
    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      ingredients: ingList,
    );
  }
}
