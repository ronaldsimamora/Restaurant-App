import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'local_database_provider.dart';
import '../../screens/restaurant_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, provider, child) {
          final restaurants = provider.restaurantList;

          if (restaurants.isEmpty) {
            return const Center(child: Text("No favorite restaurant yet"));
          }

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(restaurant.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📍 ${restaurant.city}"),
                      Text("⭐ ${restaurant.rating}"),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailPage(id: restaurant.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
