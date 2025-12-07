import 'package:flutter/material.dart';
import 'package:mis_lab2/models/category.dart';
import 'package:mis_lab2/models/meal.dart';
import 'package:mis_lab2/widgets/meal_grid.dart';
import 'package:mis_lab2/services/api_service.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  late Category _category;
  List<Meal> _allMeals = [];
  List<Meal> _meals = [];
  bool _isLoading = true;
  bool _initialized = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _category = ModalRoute.of(context)!.settings.arguments as Category;
      _initialized = true;
      _loadMeals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: Text(
          _category.name,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/favourites");
            },
            tooltip: "Favourites",
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.white),
            onPressed: _loadAndNavigateToRandomMeal,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search meals...",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _onSearchSubmitted(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: _onSearchSubmitted,
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _meals.isEmpty
                      ? const Center(
                          child: Text("No meals found for this category."),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: MealGrid(meals: _meals),
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> _loadMeals() async {
    try {
      final apiService = ApiService();
      final meals = await apiService.loadMealsForCategory(_category.name);

      setState(() {
        _meals = meals;
        _allMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading meals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) async {
    setState(() {
      _isLoading = true;
    });

    if (query.isEmpty) {
      setState(() {
        _meals = _allMeals;
        _isLoading = false;
      });
      return;
    }

    try {
      final apiService = ApiService();
      final results = await apiService.searchMeals(query, _category.name);

      setState(() {
        _meals = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAndNavigateToRandomMeal() async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fetching a random meal...')));

    try {
      final apiService = ApiService();
      final randomMeal = await apiService.loadRandomMeal();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      await Navigator.pushNamed(context, "/details", arguments: randomMeal);
    } catch (e) {
      debugPrint('Error loading random meal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load random meal. Please try again.'),
        ),
      );
    }
  }
}
