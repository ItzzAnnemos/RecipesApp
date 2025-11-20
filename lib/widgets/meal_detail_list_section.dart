import 'package:flutter/material.dart';

class MealDetailSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isInstruction;

  const MealDetailSection({
    super.key,
    required this.title,
    required this.items,
    this.isInstruction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ),

        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isInstruction ? '${index + 1}.' : '•',
                  style: TextStyle(
                    fontWeight: isInstruction
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 16,
                    color: isInstruction ? Colors.black : Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
