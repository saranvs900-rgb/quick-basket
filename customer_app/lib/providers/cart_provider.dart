import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  final String unit;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.unit,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.total);

  double get deliveryFee => subtotal >= 499 ? 0 : 20;
  double get grandTotal => subtotal + deliveryFee;

  void addItem({
    required String productId,
    required String name,
    required double price,
    String? imageUrl,
    required String unit,
  }) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
    } else {
      _items[productId] = CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        unit: unit,
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity = quantity;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
