import 'package:flutter/material.dart';
import '../models/food.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Food> _favorites = [];

  List<Food> get favorites => _favorites;

  bool isFavorite(Food food) {
    return _favorites.any((f) => f.name == food.name);
  }

  void toggleFavorite(Food food) {
    if (isFavorite(food)) {
      _favorites.removeWhere((f) => f.name == food.name);
    } else {
      _favorites.add(food);
    }
    notifyListeners();
  }
}
