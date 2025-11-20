import 'package:flutter/material.dart';
import 'package:mis_lab2/models/meal.dart';
import 'package:mis_lab2/widgets/meal_detail_list_section.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailsContent extends StatelessWidget {
  final Meal meal;

  const MealDetailsContent({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: meal.id,
            child: Image.network(
              meal.image,
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Divider(height: 32),

                MealDetailSection(
                  title: 'Ingredients (${meal.ingredients.length}) 🥗',
                  items: meal.ingredients,
                ),

                const SizedBox(height: 24),

                MealDetailSection(
                  title: 'Instructions 👨‍🍳',
                  items: meal.instructions,
                  isInstruction: true,
                ),

                if (meal.youtubeLink != null && meal.youtubeLink!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextButton.icon(
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Tutorial on YouTube'),
                      onPressed: () {
                        _launchYouTubeUrl();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchYouTubeUrl() async {
    final Uri url = Uri.parse(meal.youtubeLink!);

    if (!await canLaunchUrl(url)) {
      print('Could not launch ${meal.youtubeLink}');
    }

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
