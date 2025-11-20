import 'package:flutter/material.dart';
import 'package:mis_lab2/models/category.dart';
import 'package:mis_lab2/widgets/category_card.dart';

class CategoryGrid extends StatefulWidget {
  final List<Category> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  State<StatefulWidget> createState() => _CategoryGrid();
}

class _CategoryGrid extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 200 / 320,
      ),
      itemCount: widget.categories.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CategoryCard(category: widget.categories[index]);
      },
    );
  }
}
