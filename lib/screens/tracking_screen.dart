// ══════════════════════════════════════════
// screens/tracking_screen.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  static const _stepTitles = [
    'Order Placed',
    'Confirmed',
    'Preparing',
    'Out for Delivery',
    'Delivered'
  ];

  static const _stepSubtitles = [
    'Your order has been received',
    'Restaurant confirmed your order',
    'Chef is preparing your food',
    'Rider is on the way',
    'Enjoy your meal!',
  ];

  static const _stepIcons = [
    Icons.receipt_long_outlined,
    Icons.check_circle_outline,
    Icons.restaurant_outlined,
    Icons.delivery_dining_outlined,
    Icons.home_outlined,
  ];

  @override
  Widget build(BuildContext ctx) {
    final order = ctx.watch<OrderProvider>().latest;

    if (order == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(title: const Text('Track Order')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delivery_dining_outlined,
                  size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text('No active orders',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    final statusIdx = OrderStatus.values.indexOf(order.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(title: Text('Order #${order.id.substring(3, 9)}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(          // ← Fixed here
          children: [
            // ETA card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF9F71)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Estimated Delivery',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    order.status == OrderStatus.delivered
                        ? 'Delivered! 🎉'
                        : '${30 - (statusIdx * 6)} - ${35 - (statusIdx * 6)} mins',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(order.restaurantName,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status stepper
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(_stepTitles.length, (i) {
                  final done = statusIdx >= i;
                  final active = statusIdx == i;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: done
                                  ? const Color(0xFFFF6B35)
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              done ? Icons.check : _stepIcons[i],
                              color: done ? Colors.white : Colors.grey,
                              size: 18,
                            ),
                          ),
                          if (i < _stepTitles.length - 1)
                            Container(
                              width: 2,
                              height: 40,
                              color: done
                                  ? const Color(0xFFFF6B35)
                                  : Colors.grey.shade200,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 34),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _stepTitles[i],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: done
                                      ? const Color(0xFF1A1A1A)
                                      : Colors.grey,
                                ),
                              ),
                              if (active)
                                Text(
                                  _stepSubtitles[i],
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Delivery agent
            if (statusIdx >= 3)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFFEDE6),
                      child: Icon(Icons.person,
                          color: Color(0xFFFF6B35), size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rahul Sharma',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        Text('Your delivery partner',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor:
                      const Color(0xFFFF6B35).withOpacity(0.1),
                      child: const Icon(Icons.phone,
                          color: Color(0xFFFF6B35)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}