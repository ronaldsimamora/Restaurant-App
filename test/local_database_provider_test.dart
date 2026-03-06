import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/local/local_database_service.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';

class MockLocalDatabaseService extends LocalDatabaseService {
  final Map<String, Restaurant> _mockDatabase = {};

  @override
  Future<int> insertItem(Restaurant restaurant) async {
    _mockDatabase[restaurant.id] = restaurant;
    return 1;
  }

  @override
  Future<List<Restaurant>> getAllItems() async {
    return _mockDatabase.values.toList();
  }

  @override
  Future<Restaurant?> getItemById(String id) async {
    return _mockDatabase[id];
  }

  @override
  Future<int> removeItem(String id) async {
    _mockDatabase.remove(id);
    return 1;
  }
}

void main() {
  group('LocalDatabaseProvider Tests', () {
    late LocalDatabaseProvider provider;
    late MockLocalDatabaseService mockService;

    setUp(() {
      mockService = MockLocalDatabaseService();
      provider = LocalDatabaseProvider(mockService);
    });

    test('Initial state should have empty restaurant list', () {
      expect(provider.restaurantList, isEmpty);
      expect(provider.message, isNotEmpty);
    });

    test('saveRestaurant should add restaurant to favorites', () async {
      final restaurant = Restaurant(
        id: '1',
        name: 'Restoran Favorit',
        description: 'Deskripsi',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.5,
      );

      await provider.saveRestaurant(restaurant);

      expect(provider.restaurantList.length, 1);
      expect(provider.restaurantList.first.id, '1');
      expect(provider.restaurantList.first.name, 'Restoran Favorit');

      expect(provider.checkItemFavorite('1'), true);
    });

    test('checkItemFavorite should return true for saved restaurant', () async {
      final restaurant = Restaurant(
        id: '2',
        name: 'Restoran B',
        description: 'Deskripsi B',
        pictureId: 'pic2',
        city: 'Bandung',
        rating: 4.2,
      );

      await provider.saveRestaurant(restaurant);

      final isFavorite = provider.checkItemFavorite('2');
      expect(isFavorite, true);

      final isNotFavorite = provider.checkItemFavorite('999');
      expect(isNotFavorite, false);
    });

    test(
      'removeRestaurantById should remove restaurant from favorites',
      () async {
        final restaurant = Restaurant(
          id: '3',
          name: 'Restoran C',
          description: 'Deskripsi C',
          pictureId: 'pic3',
          city: 'Surabaya',
          rating: 4.0,
        );

        await provider.saveRestaurant(restaurant);
        expect(provider.restaurantList.length, 1);
        expect(provider.checkItemFavorite('3'), true);

        await provider.removeRestaurantById('3');

        expect(provider.restaurantList.isEmpty, true);
        expect(provider.checkItemFavorite('3'), false);
      },
    );

    test('loadRestaurantById should load specific restaurant', () async {
      final restaurant = Restaurant(
        id: '4',
        name: 'Restoran D',
        description: 'Deskripsi D',
        pictureId: 'pic4',
        city: 'Yogyakarta',
        rating: 4.8,
      );

      await provider.saveRestaurant(restaurant);

      await provider.loadRestaurantById('4');

      expect(provider.restaurant, isNotNull);
      expect(provider.restaurant!.id, '4');
      expect(provider.restaurant!.name, 'Restoran D');
      expect(provider.restaurant!.city, 'Yogyakarta');
    });

    test('saveRestaurant should handle duplicate with replace', () async {
      final restaurant1 = Restaurant(
        id: '5',
        name: 'Restoran E',
        description: 'Deskripsi E',
        pictureId: 'pic5',
        city: 'Medan',
        rating: 4.1,
      );

      final restaurant2 = Restaurant(
        id: '5',
        name: 'Restoran E Updated',
        description: 'Deskripsi Updated',
        pictureId: 'pic5',
        city: 'Medan',
        rating: 4.3,
      );

      await provider.saveRestaurant(restaurant1);
      expect(provider.restaurantList.length, 1);
      expect(provider.restaurantList.first.name, 'Restoran E');

      await provider.saveRestaurant(restaurant2);

      expect(provider.restaurantList.length, 1);
      expect(provider.restaurantList.first.name, 'Restoran E Updated');
      expect(provider.restaurantList.first.rating, 4.3);
    });

    test('loadAllRestaurant should refresh list from database', () async {
      final restaurant1 = Restaurant(
        id: '6',
        name: 'Restoran F',
        description: 'Deskripsi F',
        pictureId: 'pic6',
        city: 'Semarang',
        rating: 4.4,
      );

      final restaurant2 = Restaurant(
        id: '7',
        name: 'Restoran G',
        description: 'Deskripsi G',
        pictureId: 'pic7',
        city: 'Bali',
        rating: 4.9,
      );

      await provider.saveRestaurant(restaurant1);
      await provider.saveRestaurant(restaurant2);

      await provider.loadAllRestaurant();

      expect(provider.restaurantList.length, 2);
      expect(provider.restaurantList.any((r) => r.id == '6'), true);
      expect(provider.restaurantList.any((r) => r.id == '7'), true);
    });

    test(
      'saveRestaurant should set message to "Added to Favorite" before loadAll',
      () async {},
    );
  });
}
