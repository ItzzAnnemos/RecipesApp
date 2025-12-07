import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meal.dart';

class FavouritesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return user.uid;
  }

  Future<void> addOrRemoveToFavourites(Meal meal) async {
    final doc = _db
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(meal.id.toString());

    final snapshot = await doc.get();

    if (snapshot.exists) {
      await doc.delete();
    } else {
      await doc.set(meal.toJson()..['timestamp'] = FieldValue.serverTimestamp());
    }
  }

  Future<bool> isFavorite(int mealId) async {
    final doc = await _db
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(mealId.toString())
        .get();

    return doc.exists;
  }

  Stream<List<Meal>> getFavoritesStream() {
    return _db
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Meal(
          id: data['id'],
          name: data['name'],
          image: data['image'],
          instructions: List<String>.from(data['instructions'] ?? []),
          ingredients: List<String>.from(data['ingredients'] ?? []),
          youtubeLink: data['youtubeLink'] ?? '',
          category: data['category'] ?? '',
        );
      }).toList();
    });
  }
}
