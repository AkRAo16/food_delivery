
import 'package:foodhansi/models/menu_item.dart';

class Restaurant {
  final String id, name, cuisine, imageUrl, address;
  final double rating;
  final int deliveryTime, minOrder;
  final bool isOpen;
  final List<MenuCategory> menu;

  const Restaurant({
    required this.id, required this.name, required this.cuisine,
    required this.imageUrl, required this.address, required this.rating,
    required this.deliveryTime, required this.minOrder,
    this.isOpen = true, required this.menu,
  });
}

class MenuCategory {
  final String name;
  final List<MenuItem> items;
  const MenuCategory({required this.name, required this.items});
}


// ══════════════════════════════════════════
