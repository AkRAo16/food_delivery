
// ══════════════════════════════════════════
// data/mock_data.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../models/restaurant.dart';

final mockRestaurants = [
  Restaurant(
    id: 'r1', name: 'Spice Garden', cuisine: 'North Indian • Mughlai',
    imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800',
    address: 'Bandra West, Mumbai',
    rating: 4.5, deliveryTime: 30, minOrder: 200,
    menu: [
      MenuCategory(name: 'Starters', items: [
        MenuItem(id: 'sg1', name: 'Paneer Tikka', isVeg: true, price: 220,
            description: 'Grilled cottage cheese with spices',
            imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=400'),
        MenuItem(id: 'sg2', name: 'Chicken Seekh', isVeg: false, price: 280,
            description: 'Minced chicken on skewers',
            imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400'),
      ]),
      MenuCategory(name: 'Mains', items: [
        MenuItem(id: 'sg3', name: 'Dal Makhani', isVeg: true, price: 180,
            description: 'Slow-cooked black lentils in creamy tomato base',
            imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400'),
        MenuItem(id: 'sg4', name: 'Butter Chicken', isVeg: false, price: 320,
            description: 'Tender chicken in rich buttery tomato gravy',
            imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400'),
      ]),
    ],
  ),
  Restaurant(
    id: 'r2', name: 'Pizza Paradiso', cuisine: 'Italian • Pizza',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
    address: 'Andheri East, Mumbai',
    rating: 4.2, deliveryTime: 25, minOrder: 300,
    menu: [
      MenuCategory(name: 'Pizzas', items: [
        MenuItem(id: 'pp1', name: 'Margherita', isVeg: true, price: 349,
            description: 'Classic tomato, mozzarella & basil',
            imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400'),
        MenuItem(id: 'pp2', name: 'Pepperoni', isVeg: false, price: 449,
            description: 'Loaded pepperoni with mozzarella',
            imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400'),
      ]),
      MenuCategory(name: 'Sides', items: [
        MenuItem(id: 'pp3', name: 'Garlic Bread', isVeg: true, price: 129,
            description: 'Toasted baguette with garlic butter',
            imageUrl: 'https://images.unsplash.com/photo-1619985702659-2c47174640bd?w=400'),
      ]),
    ],
  ),
  Restaurant(
    id: 'r3', name: 'Sushi Zen', cuisine: 'Japanese • Sushi',
    imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800',
    address: 'Lower Parel, Mumbai',
    rating: 4.7, deliveryTime: 40, minOrder: 500,
    menu: [
      MenuCategory(name: 'Rolls', items: [
        MenuItem(id: 'sz1', name: 'California Roll', isVeg: false, price: 380,
            description: 'Crab, avocado & cucumber',
            imageUrl: 'https://images.unsplash.com/photo-1617196034738-26c5f7c977ce?w=400'),
        MenuItem(id: 'sz2', name: 'Veggie Roll', isVeg: true, price: 280,
            description: 'Cucumber, avocado & pickled radish',
            imageUrl: 'https://images.unsplash.com/photo-1617196034183-421b4040d5c7?w=400'),
      ]),
    ],
  ),
  Restaurant(
    id: 'r4', name: 'Burger Barn', cuisine: 'American • Burgers',
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800',
    address: 'Powai, Mumbai',
    rating: 4.0, deliveryTime: 20, minOrder: 150,
    menu: [
      MenuCategory(name: 'Burgers', items: [
        MenuItem(id: 'bb1', name: 'Classic Cheeseburger', isVeg: false, price: 249,
            description: 'Beef patty, cheddar, lettuce & pickles',
            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400'),
        MenuItem(id: 'bb2', name: 'Veggie Delight', isVeg: true, price: 199,
            description: 'Black bean patty with fresh veggies',
            imageUrl: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=400'),
      ]),
    ],
  ),
];

const categories = ['All', '🍕 Pizza', '🍔 Burgers', '🍱 Biryani', '🍣 Sushi', '🌮 Wraps'];


// ══════════════════════════════════════════
// widgets/restaurant_card.dart
// ══════════════════════════════════════════
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(children: [
              Image.network(restaurant.imageUrl, height: 160, width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160, color: const Color(0xFFFFEDE6),
                    child: const Icon(Icons.restaurant, size: 48, color: Color(0xFFFF6B35)),
                  )),
              if (!restaurant.isOpen)
                Container(height: 160, color: Colors.black45,
                    alignment: Alignment.center,
                    child: const Text('CLOSED', style: TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(restaurant.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF21A67A),
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, color: Colors.white, size: 12),
                    const SizedBox(width: 3),
                    Text('${restaurant.rating}', style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
              const SizedBox(height: 4),
              Text(restaurant.cuisine, style: TextStyle(
                  color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 10),
              Row(children: [
                _chip(Icons.access_time_outlined, '${restaurant.deliveryTime} min'),
                const SizedBox(width: 12),
                _chip(Icons.currency_rupee, 'Min ₹${restaurant.minOrder}'),
                const SizedBox(width: 12),
                _chip(Icons.delivery_dining_outlined, 'Free delivery'),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _chip(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: Colors.grey[500]),
      const SizedBox(width: 3),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ],
  );
}

