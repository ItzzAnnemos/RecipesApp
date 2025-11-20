import 'package:flutter/material.dart';
import 'package:mis_lab2/screens/home.dart';
import 'package:mis_lab2/screens/meal_details.dart';
import 'package:mis_lab2/screens/meals_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рецепти - 223125',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => const HomePage(title: 'Рецепти - 223125'),
        "/meals": (context) => const MealsPage(),
        '/details': (context) => const MealDetailsPage(),
      },
    );
  }
}
