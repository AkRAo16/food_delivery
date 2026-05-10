// ══════════════════════════════════════════
// models/menu_item.dart
// ══════════════════════════════════════════
class MenuItem {
  final String id, name, description, imageUrl;
  final double price;
  final bool isVeg;

  const MenuItem({
    required this.id, required this.name, required this.description,
    required this.imageUrl, required this.price, required this.isVeg,
  });
}
