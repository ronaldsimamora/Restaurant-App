import 'package:flutter/material.dart';
import '../../data/local/local_database_service.dart';
import '../../data/models/restaurant.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service) {
    _init();
  }

  String _message = "";
  String get message => _message;

  List<Restaurant> _restaurantList = [];
  List<Restaurant> get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  Future<void> _init() async {
    await loadAllRestaurant();
  }

  Future<void> saveRestaurant(Restaurant value) async {
    try {
      await _service.insertItem(value);
      _message = "Added to Favorite";
      await loadAllRestaurant();
    } catch (e) {
      _message = "Failed to save data";
    }
    notifyListeners();
  }

  Future<void> loadAllRestaurant() async {
    try {
      final result = await _service.getAllItems();
      _restaurantList = result;
      _restaurant = null;
      _message = "Data loaded";
    } catch (e) {
      _message = "Failed to load data";
    }
    notifyListeners();
  }

  Future<void> loadRestaurantById(String id) async {
    try {
      _restaurant = await _service.getItemById(id);
      _message = "Data loaded";
    } catch (e) {
      _message = "Failed to load data";
    }
    notifyListeners();
  }

  Future<void> removeRestaurantById(String id) async {
    try {
      await _service.removeItem(id);
      _message = "Removed from Favorite";
      await loadAllRestaurant();
    } catch (e) {
      _message = "Failed to remove data";
    }
    notifyListeners();
  }

  bool checkItemFavorite(String id) {
    return _restaurantList.any((item) => item.id == id);
  }
}
