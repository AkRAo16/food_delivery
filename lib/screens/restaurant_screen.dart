
// ══════════════════════════════════════════
// screens/restaurant_screen.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/restaurant.dart';
import '../providers/cart_provider.dart';
import '../widgets/menu_item_tile.dart';

class RestaurantScreen extends StatefulWidget {
  final String id;
  const RestaurantScreen({super.key, required this.id});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late Restaurant _restaurant;

  @override
  void initState() {
    super.initState();
    _restaurant = mockRestaurants.firstWhere((r) => r.id == widget.id);
    _tabs = TabController(length: _restaurant.menu.length, vsync: this);
  }

  @override
  Widget build(BuildContext ctx) {
    final cart = ctx.watch<CartProvider>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(_restaurant.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFFFFEDE6))),
            ),
            leading: GestureDetector(
              onTap: () => ctx.pop(),
              child: Container(margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.white,
                      shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A))),
            ),
          ),
          SliverToBoxAdapter(child: _buildInfo()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabDelegate(TabBar(
              controller: _tabs, isScrollable: true,
              labelColor: const Color(0xFFFF6B35),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFFF6B35),
              tabs: _restaurant.menu.map((c) => Tab(text: c.name)).toList(),
            )),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: _restaurant.menu.map((cat) => ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: cat.items.length,
            itemBuilder: (_, i) {
              final item = cat.items[i];
              return MenuItemTile(
                item: item,
                quantity: cart.quantityOf(item.id),
                onAdd: () => cart.add(item, _restaurant.id, _restaurant.name),
                onRemove: () => cart.remove(item.id),
              );
            },
          )).toList(),
        ),
      ),
      bottomNavigationBar: cart.totalItems > 0
          ? SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: ElevatedButton(
          onPressed: () => ctx.push('/cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text('${cart.totalItems} items',
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                const Text('View Cart', style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16)),
                Text('₹${cart.subtotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ]),
        ),
      ))
          : null,
    );
  }

  Widget _buildInfo() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_restaurant.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(_restaurant.cuisine, style: TextStyle(color: Colors.grey[600])),
      const SizedBox(height: 12),
      Row(children: [
        _infoBox(Icons.star, '${_restaurant.rating}', Colors.amber),
        const SizedBox(width: 12),
        _infoBox(Icons.access_time, '${_restaurant.deliveryTime} min', Colors.blue),
        const SizedBox(width: 12),
        _infoBox(Icons.currency_rupee, 'Min ${_restaurant.minOrder}', Colors.green),
      ]),
    ]),
  );

  Widget _infoBox(IconData icon, String text, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    ],
  );
}

class _TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabDelegate(this.tabBar);

  @override double get minExtent => tabBar.preferredSize.height + 1;
  @override double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(_, __, ___) => Container(
    color: Colors.white,
    child: Column(children: [tabBar,
      Divider(height: 1, color: Colors.grey.shade200)]),
  );

  @override
  bool shouldRebuild(covariant _) => true;
}

