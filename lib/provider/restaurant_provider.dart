import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant.dart';

sealed class RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> data;
  RestaurantLoaded(this.data);
}

class RestaurantError extends RestaurantState {
  final String message;
  final String userMessage; // Tambahkan user-friendly message
  RestaurantError(this.message, this.userMessage);
}

class RestaurantProvider extends ChangeNotifier {
  late final ApiService apiService;

  RestaurantProvider([ApiService? apiService]) {
    this.apiService = apiService ?? ApiService();
  }

  RestaurantState _state = RestaurantLoading();
  RestaurantState get state => _state;

  String _getUserFriendlyMessage(String error) {
    if (error.contains('no_internet')) {
      return 'Tidak ada koneksi internet. Silakan periksa koneksi Anda dan coba lagi.';
    } else if (error.contains('timeout')) {
      return 'Koneksi lambat. Silakan periksa jaringan Anda dan coba lagi.';
    } else {
      return 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      _state = RestaurantLoading();
      notifyListeners();

      final data = await apiService.fetchRestaurantList();

      _state = RestaurantLoaded(data);
      notifyListeners();
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _state = RestaurantError(errorMsg, _getUserFriendlyMessage(errorMsg));
      notifyListeners();
    }
  }
}
