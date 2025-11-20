class Meal {
  int id;
  String name;
  String image;
  List<String> instructions;
  List<String> ingredients;
  String? youtubeLink;
  String? category;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    this.youtubeLink,
    this.category,
  });

  factory Meal.fromJson(Map<String, dynamic> data) {
    List<String> ingredientsList = [];
    List<String> instructionsList = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = data['strIngredient$i'];
      final measure = data['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          ingredient.toString() != "null") {
        ingredientsList.add("${measure ?? ''} $ingredient".trim());
      }
    }

    if (data['strInstructions'] != null) {
      instructionsList = data['strInstructions']
          .toString()
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    }

    return Meal(
      id: int.parse(data['idMeal']),
      name: data['strMeal'] ?? '',
      image: data['strMealThumb'] ?? '',
      instructions: instructionsList,
      ingredients: ingredientsList,
      youtubeLink: data['strYoutube'] ?? '',
      category: data['strCategory'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'instructions': instructions,
    'ingredients': ingredients,
    'youtubeLink': youtubeLink,
  };
}
