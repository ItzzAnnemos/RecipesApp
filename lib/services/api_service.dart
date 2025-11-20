import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mis_lab2/models/category.dart';
import 'package:mis_lab2/models/meal.dart';

class ApiService {
  Future<List<Category>> loadCategoryList() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data['categories'];

      return categoriesJson.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> loadMealsForCategory(String category) async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List mealsList = data['meals'];

      return mealsList.map((e) {
        final meal = Meal.fromJson(e);
        meal.category = category;
        return meal;
      }).toList();
    } else {
      throw Exception('Failed to load meals for category: $category');
    }
  }

  Future<List<Meal>> searchMeals(String query, String category) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search meals');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    final List mealsJson = data['meals'];

    return mealsJson
        .map((e) => Meal.fromJson(e))
        .where((meal) => meal.category?.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<Meal> lookupMealDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];

      if (mealsJson.isEmpty) {
        throw Exception('No meal found for ID: $id');
      }

      final mealDetailsJson = mealsJson[0] as Map<String, dynamic>;

      return Meal.fromJson(mealDetailsJson);

    } else {
      throw Exception('Failed to load meal details for ID: $id');
    }
  }

  Future<Meal> loadRandomMeal() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];

      if (mealsJson.isEmpty) {
        throw Exception('No random meal found.');
      }

      final mealDetailsJson = mealsJson[0] as Map<String, dynamic>;

      return Meal.fromJson(mealDetailsJson);

    } else {
      throw Exception('Failed to load random meal.');
    }
  }
}
