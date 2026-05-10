
// ══════════════════════════════════════════
// screens/profile_screen.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final orders = ctx.watch<OrderProvider>().orders;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(title: const Text('My Profile'),
          actions: [IconButton(onPressed: () {},
              icon: const Icon(Icons.edit_outlined))]),
      body: ListView(children: [
        // Profile header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const CircleAvatar(radius: 32, backgroundColor: Color(0xFFFFEDE6),
                child: Icon(Icons.person, color: Color(0xFFFF6B35), size: 36)),
            const SizedBox(width: 16),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Priya Mehta', style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 18)),
              Text('priya.mehta@email.com', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 4),
              Text('+91 98765 43210', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ]),
          ]),
        ),

        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            _statCard('${orders.length}', 'Total Orders'),
            const SizedBox(width: 12),
            _statCard('₹${orders.fold(0.0, (s, o) => s + o.total).toStringAsFixed(0)}',
                'Total Spent'),
            const SizedBox(width: 12),
            _statCard('4.8 ⭐', 'Avg Rating'),
          ]),
        ),

        const SizedBox(height: 16),

        // Order history
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text('Order History', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        if (orders.isEmpty)
          const Padding(padding: EdgeInsets.all(32),
              child: Center(child: Text('No orders yet',
                  style: TextStyle(color: Colors.grey))))
        else
          ...orders.take(5).map((o) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const CircleAvatar(backgroundColor: Color(0xFFFFEDE6), radius: 22,
                  child: Icon(Icons.restaurant, color: Color(0xFFFF6B35), size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.restaurantName, style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                    Text('${o.items.length} items • ₹${o.total.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: o.status == OrderStatus.delivered
                            ? Colors.green.withOpacity(0.1)
                            : const Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(_statusLabel(o.status), style: TextStyle(
                        color: o.status == OrderStatus.delivered
                            ? Colors.green : const Color(0xFFFF6B35),
                        fontSize: 11, fontWeight: FontWeight.w600))),
                const SizedBox(height: 4),
                TextButton(onPressed: () => ctx.go('/home'),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text('Reorder', style: TextStyle(
                        color: Color(0xFFFF6B35), fontSize: 12))),
              ]),
            ]),
          )),

        const SizedBox(height: 16),

        // Settings
        _settingsTile(Icons.location_on_outlined, 'Saved Addresses'),
        _settingsTile(Icons.payment_outlined, 'Payment Methods'),
        _settingsTile(Icons.help_outline, 'Help & Support'),
        _settingsTile(Icons.logout, 'Logout', color: Colors.red),
        const SizedBox(height: 30),
      ]),
    );
  }

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed: return 'Placed';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.preparing: return 'Preparing';
      case OrderStatus.outForDelivery: return 'On the way';
      case OrderStatus.delivered: return 'Delivered';
    }
  }

  Widget _statCard(String value, String label) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: const TextStyle(
            fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFFFF6B35))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11),
            textAlign: TextAlign.center),
      ]),
    ),
  );

  Widget _settingsTile(IconData icon, String label, {Color? color}) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF1A1A1A)),
      title: Text(label, style: TextStyle(color: color ?? const Color(0xFF1A1A1A),
          fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () {},
    ),
  );
}