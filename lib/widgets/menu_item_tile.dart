
// ══════════════════════════════════════════
// widgets/menu_item_tile.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MenuItemTile({super.key, required this.item, required this.quantity,
    required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(item.imageUrl, width: 80, height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 80, height: 80, color: const Color(0xFFF0F0F0),
                  child: const Icon(Icons.fastfood, color: Color(0xFFFF6B35)))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 14, height: 14,
              decoration: BoxDecoration(
                  border: Border.all(color: item.isVeg ? Colors.green : Colors.red),
                  borderRadius: BorderRadius.circular(2)),
              child: Center(child: CircleAvatar(
                radius: 4,
                backgroundColor: item.isVeg ? Colors.green : Colors.red,
              )),
            ),
            const SizedBox(width: 6),
            Expanded(child: Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          ]),
          const SizedBox(height: 4),
          Text(item.description,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('₹${item.price.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w700,
                    fontSize: 15, color: Color(0xFF1A1A1A))),
            quantity == 0
                ? GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFF6B35)),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('ADD', style: TextStyle(
                    color: Color(0xFFFF6B35), fontWeight: FontWeight.w700,
                    fontSize: 13)),
              ),
            )
                : Row(children: [
              _btn(Icons.remove, onRemove),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('$quantity',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
              _btn(Icons.add, onAdd),
            ]),
          ]),
        ])),
      ]),
    );
  }

  Widget _btn(IconData icon, VoidCallback fn) => GestureDetector(
    onTap: fn,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(color: const Color(0xFFFF6B35),
          borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: Colors.white, size: 16),
    ),
  );
}