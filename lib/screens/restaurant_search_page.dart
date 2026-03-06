import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/api/api_service.dart';
import '../provider/restaurant_search_provider.dart';
import '../data/models/restaurant.dart';
import 'restaurant_detail_page.dart';

class RestaurantSearchPage extends StatelessWidget {
  const RestaurantSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantSearchProvider(ApiService()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantSearchProvider>();
    final state = provider.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Restoran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari nama restoran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                context.read<RestaurantSearchProvider>().search(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (state) {
                SearchInitial() => const Center(
                  child: Text('Ketik nama restoran untuk mencari'),
                ),
                SearchLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                SearchLoaded(data: final restaurants) =>
                  restaurants.isEmpty
                      ? const Center(child: Text('Restoran tidak ditemukan'))
                      : ListView.builder(
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            return _restaurantCard(context, restaurants[index]);
                          },
                        ),
                SearchError(userMessage: final msg) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _restaurantCard(BuildContext context, Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        title: Text(restaurant.name),
        subtitle: Text(restaurant.city),
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
  }
}
