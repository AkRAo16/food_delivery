
// ══════════════════════════════════════════
// providers/order_provider.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';

import '../models/order.dart';
import '../providers/cart_provider.dart';
class OrderProvider extends ChangeNotifier {
  final List<AppOrder> _orders = [];
  List<AppOrder> get orders => List.unmodifiable(_orders.reversed.toList());

  AppOrder? get latest => _orders.isEmpty ? null : _orders.last;

  void placeOrder(CartProvider cart) {
    final o = AppOrder(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      restaurantName: cart.restaurantName ?? 'Restaurant',
      items: List.from(cart.items),
      total: cart.total,
      placedAt: DateTime.now(),
    );
    _orders.add(o);
    _simulateProgress(o);
    notifyListeners();
  }

  void _simulateProgress(AppOrder o) async {
    final steps = [
      OrderStatus.confirmed, OrderStatus.preparing,
      OrderStatus.outForDelivery, OrderStatus.delivered
    ];
    for (final s in steps) {
      await Future.delayed(const Duration(seconds: 8));
      o.status = s;
      notifyListeners();
    }
  }
}
