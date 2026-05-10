
// ══════════════════════════════════════════
// widgets/category_chip.dart
// ══════════════════════════════════════════
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.label,
    required this.selected, required this.onTap});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected
              ? const Color(0xFFFF6B35) : Colors.grey.shade300),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? Colors.white : Colors.grey[700],
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 13,
        )),
      ),
    );
  }
}

