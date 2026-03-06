import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class MockApiServiceError extends ApiService {
  @override
  Future<List<Restaurant>> fetchRestaurantList() async {
    throw Exception('no_internet');
  }
}

class MockApiServiceSuccess extends ApiService {
  @override
  Future<List<Restaurant>> fetchRestaurantList() async {
    return [
      Restaurant(
        id: '1',
        name: 'Restoran A',
        description: 'Deskripsi A',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.5,
      ),
    ];
  }
}

void main() {
  group('RestaurantProvider Tests', () {
    test('Initial state should be RestaurantLoading', () {
      final provider = RestaurantProvider();
      expect(provider.state, isA<RestaurantLoading>());
    });

    test(
      'fetchRestaurants should return RestaurantLoaded with data on success',
      () async {
        final mockApi = MockApiServiceSuccess();
        final provider = RestaurantProvider(mockApi);

        await provider.fetchRestaurants();

        expect(provider.state, isA<RestaurantLoaded>());

        final loadedState = provider.state as RestaurantLoaded;
        expect(loadedState.data.length, 1);
        expect(loadedState.data.first.name, 'Restoran A');
      },
    );

    test('fetchRestaurants should return RestaurantError on failure', () async {
      final mockApi = MockApiServiceError();
      final provider = RestaurantProvider(mockApi);

      await provider.fetchRestaurants();

      expect(provider.state, isA<RestaurantError>());

      final errorState = provider.state as RestaurantError;
      expect(errorState.userMessage, isNotEmpty);
      expect(errorState.message, 'no_internet');
    });

    test('fetchRestaurants should show loading state during fetch', () async {
      final mockApi = MockApiServiceSuccess();
      final provider = RestaurantProvider(mockApi);

      final future = provider.fetchRestaurants();

      expect(provider.state, isA<RestaurantLoading>());

      await future;

      expect(provider.state, isA<RestaurantLoaded>());
    });
  });
}
