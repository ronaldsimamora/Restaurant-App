import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Restaurant> data;
  SearchLoaded(this.data);
}

class SearchError extends SearchState {
  final String message;
  final String userMessage;
  SearchError(this.message, this.userMessage);
}

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider(this.apiService);

  SearchState _state = SearchInitial();
  SearchState get state => _state;

  String _getUserFriendlyMessage(String error) {
    if (error.contains('no_internet')) {
      return 'Tidak ada koneksi internet. Silakan periksa koneksi Anda dan coba lagi.';
    } else if (error.contains('timeout')) {
      return 'Koneksi lambat. Silakan periksa jaringan Anda dan coba lagi.';
    } else {
      return 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _state = SearchInitial();
      notifyListeners();
      return;
    }

    try {
      _state = SearchLoading();
      notifyListeners();

      final result = await apiService.searchRestaurant(query);

      _state = SearchLoaded(result);
      notifyListeners();
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _state = SearchError(errorMsg, _getUserFriendlyMessage(errorMsg));
      notifyListeners();
    }
  }
}
