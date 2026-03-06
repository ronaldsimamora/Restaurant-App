import 'package:flutter/material.dart';
import 'package:restaurant_app/provider/favorite/favorite_page.dart';
import 'package:restaurant_app/screens/restaurant_list_page.dart';
import 'package:restaurant_app/screens/setting/setting_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<int> _indexBottomNavBarNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _indexBottomNavBarNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<int>(
      valueListenable: _indexBottomNavBarNotifier,
      builder: (context, currentIndex, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              currentIndex == 0 ? "Restaurant App" : "Favorite Restaurants",
              style: TextStyle(color: colorScheme.onSurface),
            ),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            actions: currentIndex == 0
                ? [
                    IconButton(
                      icon: Icon(Icons.settings, color: colorScheme.onSurface),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingPage(),
                          ),
                        );
                      },
                    ),
                  ]
                : null,
          ),
          body: currentIndex == 0
              ? const RestaurantListPage()
              : const FavoritePage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              _indexBottomNavBarNotifier.value = index;
            },
            backgroundColor: colorScheme.surface,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorites",
              ),
            ],
          ),
        );
      },
    );
  }
}
