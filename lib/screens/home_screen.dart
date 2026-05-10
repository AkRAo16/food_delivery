
// ══════════════════════════════════════════
// screens/home_screen.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../models/restaurant.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _catIdx = 0;
  final _ctrl = TextEditingController();
  String _query = '';

  List<Restaurant> get _filtered => mockRestaurants.where((r) {
    final q = _query.toLowerCase();
    return q.isEmpty || r.name.toLowerCase().contains(q)
        || r.cuisine.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearch()),
          SliverToBoxAdapter(child: _buildBanner()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('${_filtered.length} restaurants nearby',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
                (c, i) => RestaurantCard(
              restaurant: _filtered[i],
              onTap: () => ctx.push('/restaurant/${_filtered[i].id}'),
            ),
            childCount: _filtered.length,
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ]),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Row(children: [
      const Icon(Icons.location_on, color: Color(0xFFFF6B35), size: 20),
      const SizedBox(width: 6),
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Deliver to', style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text('Bandra West, Mumbai', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 14)),
      ]),
      const Spacer(),
      CircleAvatar(backgroundColor: const Color(0xFFFF6B35).withOpacity(0.1),
          radius: 20,
          child: const Icon(Icons.notifications_outlined,
              color: Color(0xFFFF6B35), size: 22)),
    ]),
  );

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.all(16),
    child: TextField(
      controller: _ctrl,
      onChanged: (v) => setState(() => _query = v),
      decoration: InputDecoration(
        hintText: 'Search restaurants or cuisines...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  Widget _buildBanner() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    height: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B35), Color(0xFFFF9F71)],
      ),
    ),
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Free Delivery', style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('On your first 3 orders!',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Order Now', style: TextStyle(
                  color: Color(0xFFFF6B35), fontWeight: FontWeight.w700, fontSize: 9)),
            ),
          ])),
      const Icon(Icons.delivery_dining, color: Colors.white, size: 70),
    ]),
  );

  Widget _buildCategories() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: categories.length,
        itemBuilder: (_, i) => CategoryChip(
          label: categories[i],
          selected: _catIdx == i,
          onTap: () => setState(() => _catIdx = i),
        ),
      ),
    ),
  );
}

