import 'package:flutter/material.dart';
import 'package:mis_lab2/models/category.dart';
import 'package:mis_lab2/services/api_service.dart';
import 'package:mis_lab2/widgets/category_grid.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
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
      body: _isLoading || _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search categories...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterCategories,
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: CategoryGrid(
                            categories: _filteredCategories.isEmpty
                                ? _categories
                                : _filteredCategories,
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> _loadCategories() async {
    try {
      final apiService = ApiService();
      final categories = await apiService.loadCategoryList();

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCategories(String query) {
    setState(() {
      _filteredCategories = _categories
          .where((cat) => cat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
