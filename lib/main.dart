import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'models/restaurant.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';
import 'screens/restaurant_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/profile_screen.dart';
import 'data/mock_data.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const FoodApp(),
    ),
  );
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp.router(
      title: 'FoodRush',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          background: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
        ),
      ),
      routerConfig: _router,
    );
  }
}

final _shellKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (ctx, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        GoRoute(
          path: '/restaurant/:id',
          builder: (c, s) => RestaurantScreen(id: s.pathParameters['id']!),
        ),
        GoRoute(path: '/cart', builder: (c, s) => const CartScreen()),
        GoRoute(path: '/tracking', builder: (c, s) => const TrackingScreen()),
        GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      ],
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  final _tabs = ['/home', '/cart', '/tracking', '/profile'];
  final _icons = [Icons.home_outlined, Icons.shopping_bag_outlined,
    Icons.delivery_dining_outlined, Icons.person_outline];
  final _activeIcons = [Icons.home, Icons.shopping_bag,
    Icons.delivery_dining, Icons.person];
  final _labels = ['Home', 'Cart', 'Track', 'Profile'];

  @override
  Widget build(BuildContext ctx) {
    final cartCount = ctx.watch<CartProvider>().totalItems;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFEDE6),
        onDestinationSelected: (i) {
          setState(() => _idx = i);
          ctx.go(_tabs[i]);
        },
        destinations: List.generate(4, (i) => NavigationDestination(
          icon: Badge(
            isLabelVisible: i == 1 && cartCount > 0,
            label: Text('$cartCount'),
            child: Icon(_icons[i]),
          ),
          selectedIcon: Icon(_activeIcons[i], color: const Color(0xFFFF6B35)),
          label: _labels[i],
        )),
      ),
    );
  }
}