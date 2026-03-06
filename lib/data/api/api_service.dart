import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  final http.Client? _client;

  ApiService([this._client]);

  http.Client get _httpClient => _client ?? http.Client();

  Future<List<Restaurant>> fetchRestaurantList() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/list'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List restaurants = jsonData['restaurants'];
        return restaurants.map((e) => Restaurant.fromJson(e)).toList();
      } else {
        throw Exception('server_error');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception('no_internet');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('timeout');
      } else {
        throw Exception('server_error');
      }
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/detail/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return RestaurantDetail.fromJson(jsonData['restaurant']);
      } else {
        throw Exception('server_error');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception('no_internet');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('timeout');
      } else {
        throw Exception('server_error');
      }
    }
  }

  Future<List<Restaurant>> searchRestaurant(String query) async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$_baseUrl/search?q=$query'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List restaurants = jsonData['restaurants'];
        return restaurants.map((e) => Restaurant.fromJson(e)).toList();
      } else {
        throw Exception('server_error');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception('no_internet');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('timeout');
      } else {
        throw Exception('server_error');
      }
    }
  }

  Future<bool> submitReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/review'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id': id, 'name': name, 'review': review}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }
}
