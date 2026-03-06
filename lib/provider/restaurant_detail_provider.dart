import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/models/restaurant_detail.dart';

sealed class DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final RestaurantDetail data;
  DetailLoaded(this.data);
}

class DetailError extends DetailState {
  final String message;
  final String userMessage;
  DetailError(this.message, this.userMessage);
}

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider(this.apiService);

  DetailState _state = DetailLoading();
  DetailState get state => _state;

  String _getUserFriendlyMessage(String error) {
    if (error.contains('no_internet')) {
      return 'Tidak ada koneksi internet. Silakan periksa koneksi Anda dan coba lagi.';
    } else if (error.contains('timeout')) {
      return 'Koneksi lambat. Silakan periksa jaringan Anda dan coba lagi.';
    } else {
      return 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
    }
  }

  Future<void> fetchDetail(String id) async {
    _state = DetailLoading();
    notifyListeners();

    try {
      final result = await apiService.fetchRestaurantDetail(id);
      _state = DetailLoaded(result);
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _state = DetailError(errorMsg, _getUserFriendlyMessage(errorMsg));
    }

    notifyListeners();
  }
}
