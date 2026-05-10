// ══════════════════════════════════════════
// providers/cart_provider.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';

import '../models/menu_item.dart';
import '../models/order.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _restaurantId;
  String? _restaurantName;

  List<CartItem> get items => _items;
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  int get totalItems => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal => _items.fold(0, (s, i) => s + i.subtotal);
  double get deliveryFee => _items.isEmpty ? 0 : 35;
  double get taxes => subtotal * 0.05;
  double get total => subtotal + deliveryFee + taxes;

  void add(MenuItem item, String restId, String restName) {
    if (_restaurantId != null && _restaurantId != restId) {
      _items.clear();
    }
    _restaurantId = restId;
    _restaurantName = restName;
    final idx = _items.indexWhere((c) => c.item.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void remove(String itemId) {
    final idx = _items.indexWhere((c) => c.item.id == itemId);
    if (idx < 0) return;
    if (_items[idx].quantity > 1) {
      _items[idx].quantity--;
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  void clear() { _items.clear(); _restaurantId = null; notifyListeners(); }

  int quantityOf(String itemId) =>
      _items.firstWhere((c) => c.item.id == itemId,
          orElse: () => CartItem(item: MenuItem(
              id:'', name:'', description:'', imageUrl:'', price:0, isVeg:true
          ))).quantity;
}

