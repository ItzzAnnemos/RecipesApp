import 'package:flutter/material.dart';
import 'package:mis_lab2/models/meal.dart';
import 'package:mis_lab2/services/api_service.dart';
import 'package:mis_lab2/widgets/meal_detail_content.dart';

class MealDetailsPage extends StatefulWidget {
  const MealDetailsPage({super.key});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  Meal? _mealDetails;
  bool _isLoading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final initialMeal = ModalRoute.of(context)!.settings.arguments as Meal;
      _initialized = true;
      _loadDetails(initialMeal.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: Text(
          _mealDetails?.name ?? 'Meal Details',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mealDetails == null
          ? const Center(child: Text('Could not load meal details.'))
          : MealDetailsContent(meal: _mealDetails!),
    );
  }

  Future<void> _loadDetails(String mealId) async {
    try {
      final apiService = ApiService();
      final meal = await apiService.lookupMealDetails(mealId);

      setState(() {
        _mealDetails = meal;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading meal details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
