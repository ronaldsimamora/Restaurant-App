import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant.dart';
import '../data/models/restaurant_detail.dart'; // IMPORT INI DITAMBAHKAN
import '../provider/favorite/local_database_provider.dart';
import '../provider/restaurant_detail_provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isSubmittingNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    _isExpandedNotifier.dispose();
    _isSubmittingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (_) =>
          RestaurantDetailProvider(ApiService())..fetchDetail(widget.id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Restaurant Detail"),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, child) {
            final state = provider.state;

            return switch (state) {
              DetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),

              DetailLoaded(data: final restaurant) => _buildDetailContent(
                context,
                restaurant,
                provider,
              ),

              DetailError(userMessage: final msg) => _buildErrorSection(
                context,
                msg,
                provider,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    RestaurantDetail restaurant, // FIX: Sekarang terdefinisi
    RestaurantDetailProvider provider,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Hero(
                tag: restaurant.pictureId,
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: -24,
                right: 24,
                child: Consumer<LocalDatabaseProvider>(
                  builder: (context, dbProvider, _) {
                    final isFavorite = dbProvider.checkItemFavorite(
                      restaurant.id,
                    );

                    return Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 28,
                        ),
                        onPressed: () async {
                          final favoriteProvider = context
                              .read<LocalDatabaseProvider>();

                          final restaurantModel = Restaurant(
                            id: restaurant.id,
                            name: restaurant.name,
                            description: restaurant.description,
                            pictureId: restaurant.pictureId,
                            city: restaurant.city,
                            rating: restaurant.rating,
                          );

                          if (isFavorite) {
                            await favoriteProvider.removeRestaurantById(
                              restaurant.id,
                            );

                            if (!context.mounted) return; // FIX: Guard mounted

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Dihapus dari favorit"),
                                backgroundColor: colorScheme.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            await favoriteProvider.saveRestaurant(
                              restaurantModel,
                            );

                            if (!context.mounted) return; // FIX: Guard mounted

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Ditambahkan ke favorit"),
                                backgroundColor: colorScheme.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              restaurant.name,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  restaurant.city,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              restaurant.address,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toString(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildDescriptionSection(context, restaurant),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Foods",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _menuList(context, restaurant.foods),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Drinks",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _menuList(context, restaurant.drinks),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Customer Reviews",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ...restaurant.customerReviews.map(
            (review) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: colorScheme.surfaceContainerHighest,
              child: ListTile(
                title: Text(
                  review.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  review.review,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                trailing: Text(
                  review.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          _buildReviewForm(context, restaurant, provider),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Widget untuk deskripsi dengan Read More
  Widget _buildDescriptionSection(
    BuildContext context,
    RestaurantDetail restaurant,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (context, isExpanded, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.description,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      _isExpandedNotifier.value = !isExpanded;
                    },
                    child: Text(
                      isExpanded ? "Show Less" : "Read More",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuList(BuildContext context, List<String> items) {
    final colorScheme = Theme.of(context).colorScheme;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "Tidak ada menu",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                items[index],
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewForm(
    BuildContext context,
    RestaurantDetail restaurant,
    RestaurantDetailProvider provider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Review",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              labelText: "Your Name",
              labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reviewController,
            maxLines: 3,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              labelText: "Your Review",
              labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: _isSubmittingNotifier,
            builder: (context, isSubmitting, child) {
              return ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final name = _nameController.text.trim();
                        final review = _reviewController.text.trim();

                        if (name.isEmpty || review.isEmpty) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Nama dan review tidak boleh kosong",
                              ),
                              backgroundColor: colorScheme.error,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        _isSubmittingNotifier.value = true;

                        try {
                          final success = await ApiService().submitReview(
                            id: restaurant.id,
                            name: name,
                            review: review,
                          );

                          if (!context.mounted) return; // FIX: Guard mounted

                          if (success) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Review berhasil ditambahkan",
                                ),
                                backgroundColor: colorScheme.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );

                            _nameController.clear();
                            _reviewController.clear();

                            await provider.fetchDetail(restaurant.id);
                          } else {
                            messenger.showSnackBar(
                              SnackBar(
                                content: const Text("Gagal menambahkan review"),
                                backgroundColor: colorScheme.error,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return; // FIX: Guard mounted
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text("Error: ${e.toString()}"),
                              backgroundColor: colorScheme.error,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } finally {
                          if (context.mounted) {
                            // FIX: Guard mounted
                            _isSubmittingNotifier.value = false;
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Submit Review"),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(
    BuildContext context,
    String message,
    RestaurantDetailProvider provider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<RestaurantDetailProvider>().fetchDetail(widget.id);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: colorScheme.onPrimary,
                backgroundColor: colorScheme.primary,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
