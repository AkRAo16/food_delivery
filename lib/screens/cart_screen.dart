
// ══════════════════════════════════════════
// screens/cart_screen.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoCtrl = TextEditingController();
  bool _promoApplied = false;

  @override
  Widget build(BuildContext ctx) {
    final cart = ctx.watch<CartProvider>();
    final orders = ctx.read<OrderProvider>();

    if (cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(title: const Text('Your Cart')),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text('Your cart is empty', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              Text('Add items from a restaurant to get started',
                  style: TextStyle(color: Colors.grey[400])),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ctx.go('/home'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text('Browse Restaurants'),
              ),
            ])),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('${cart.restaurantName}'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: Colors.grey.shade200)),
      ),
      body: ListView(padding: const EdgeInsets.only(bottom: 140), children: [
        const SizedBox(height: 8),
        ...cart.items.map((ci) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Text(ci.item.name, style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
            const Spacer(),
            Row(children: [
              _qtyBtn(Icons.remove, () => ctx.read<CartProvider>().remove(ci.item.id)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('${ci.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
              _qtyBtn(Icons.add, () => ctx.read<CartProvider>()
                  .add(ci.item, cart.restaurantId!, cart.restaurantName!)),
            ]),
            const SizedBox(width: 12),
            Text('₹${ci.subtotal.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        )),
        const SizedBox(height: 12),

        // Promo code
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.local_offer_outlined, color: Color(0xFFFF6B35)),
              const SizedBox(width: 8),
              Expanded(child: TextField(
                controller: _promoCtrl,
                decoration: const InputDecoration(
                  hintText: 'Enter promo code',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              )),
              GestureDetector(
                onTap: () => setState(() => _promoApplied = _promoCtrl.text.isNotEmpty),
                child: Text(_promoApplied ? 'Applied ✓' : 'Apply',
                    style: TextStyle(
                        color: _promoApplied ? Colors.green : const Color(0xFFFF6B35),
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 12),

        // Price breakdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _row('Item total', '₹${cart.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _row('Delivery fee', '₹${cart.deliveryFee.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _row('GST (5%)', '₹${cart.taxes.toStringAsFixed(2)}'),
              if (_promoApplied) ...[
                const SizedBox(height: 8),
                _row('Promo discount', '-₹50.00', color: Colors.green),
              ],
              const Divider(height: 20),
              _row('Total', '₹${(cart.total - (_promoApplied ? 50 : 0)).toStringAsFixed(2)}',
                  bold: true, size: 16),
            ]),
          ),
        ),
        const SizedBox(height: 12),

        // Delivery address
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.home_outlined, color: Color(0xFFFF6B35))),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Home', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('Plot 24, Linking Road, Bandra West, Mumbai 400050',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ])),
              TextButton(onPressed: () {}, child: const Text('Change',
                  style: TextStyle(color: Color(0xFFFF6B35)))),
            ]),
          ),
        ),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ElevatedButton(
            onPressed: () {
              orders.placeOrder(cart);
              cart.clear();
              ctx.go('/tracking');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            child: const Text('Place Order', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback fn) => GestureDetector(
    onTap: fn,
    child: Container(width: 26, height: 26,
        decoration: BoxDecoration(color: const Color(0xFFFF6B35),
            borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: Colors.white, size: 14)),
  );

  Widget _row(String l, String r, {bool bold = false, double size = 14, Color? color}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: TextStyle(fontSize: size, color: Colors.grey[700])),
        Text(r, style: TextStyle(fontSize: size, fontWeight: bold
            ? FontWeight.w700 : FontWeight.w500, color: color)),
      ]);
}

