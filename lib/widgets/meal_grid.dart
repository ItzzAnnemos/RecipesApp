import 'package:flutter/material.dart';
import 'package:mis_lab2/models/meal.dart';
import 'package:mis_lab2/widgets/meal_card.dart';

class MealGrid extends StatefulWidget {
  final List<Meal> meals;

  const MealGrid({super.key, required this.meals});

  @override
  State<StatefulWidget> createState() => _MealGrid();
}

class _MealGrid extends State<MealGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 200 / 280,
      ),
      itemCount: widget.meals.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return MealCard(meal: widget.meals[index]);
      },
    );
  }
}
