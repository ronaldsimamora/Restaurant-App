import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('fetchRestaurantList returns List<Restaurant>', () async {
      expect(apiService.fetchRestaurantList(), isA<Future<List<Restaurant>>>());
    });

    test('fetchRestaurantDetail returns RestaurantDetail', () {
      expect(
        apiService.fetchRestaurantDetail('1'),
        isA<Future<RestaurantDetail>>(),
      );
    });

    test('searchRestaurant returns List<Restaurant>', () {
      expect(
        apiService.searchRestaurant('cafe'),
        isA<Future<List<Restaurant>>>(),
      );
    });

    test('submitReview returns bool', () {
      expect(
        apiService.submitReview(id: '1', name: 'Test', review: 'Good'),
        isA<Future<bool>>(),
      );
    });
  });
}
