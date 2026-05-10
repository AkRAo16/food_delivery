// models/order.dart

import 'package:foodhansi/models/menu_item.dart';
// ══════════════════════════════════════════
enum OrderStatus { placed, confirmed, preparing, outForDelivery, delivered }

class AppOrder {
  final String id, restaurantName;
  final List<CartItem> items;
  final double total;
  OrderStatus status;
  final DateTime placedAt;

  AppOrder({
    required this.id, required this.restaurantName,
    required this.items, required this.total,
    this.status = OrderStatus.placed,
    required this.placedAt,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
  double get subtotal => item.price * quantity;
}
