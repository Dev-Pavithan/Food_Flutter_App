import 'package:flutter/material.dart';
import '../models/food.dart';

class CartItem {
  final Food food;
  int quantity;
  final String size;

  CartItem({required this.food, this.quantity = 1, required this.size});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  double _discountPercentage = 0.0;
  String? _appliedPromoCode;

  List<CartItem> get items => _items;
  double get discountPercentage => _discountPercentage;
  String? get appliedPromoCode => _appliedPromoCode;

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + (double.parse(item.food.price) * item.quantity));
  }

  double get deliveryFee => _items.isEmpty ? 0 : 5.0;
  double get discountAmount => subtotal * (_discountPercentage / 100);
  double get total => subtotal + deliveryFee - discountAmount;

  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'DEAL20') {
      _discountPercentage = 20.0;
      _appliedPromoCode = code.toUpperCase();
      notifyListeners();
      return true;
    }
    return false;
  }

  void addToCart(Food food, int quantity, String size) {
    // Check if item with same size already exists
    final index = _items.indexWhere((item) => item.food.name == food.name && item.size == size);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(food: food, quantity: quantity, size: size));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    _items[index].quantity += delta;
    if (_items[index].quantity <= 0) {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
