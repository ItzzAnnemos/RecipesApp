import 'package:flutter/material.dart';
import 'package:mis_lab2/models/meal.dart';
import 'package:mis_lab2/services/favourites_service.dart';
import 'package:mis_lab2/widgets/meal_grid.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final FavouritesService favouritesService = FavouritesService();
  List<Meal> _meals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenToFavorites();
  }

  void _listenToFavorites() {
    favouritesService.getFavoritesStream().listen(
      (meals) {
        setState(() {
          _meals = meals;
          _isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading favorites: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _meals.isEmpty
          ? const Center(child: Text("No favorite meals yet."))
          : Padding(
        padding: const EdgeInsets.all(12),
        child: MealGrid(meals: _meals),
      ),
    );
  }
}
