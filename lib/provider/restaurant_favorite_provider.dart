import 'package:flutter/material.dart';

import 'package:restaurants_app/data/db/database_helper.dart';
import 'package:restaurants_app/data/models/restaurant_list.dart';

enum ResultStateDb { loading, noData, hasData, error }

class RestaurantFavoriteProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  RestaurantFavoriteProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  ResultStateDb _state = ResultStateDb.noData;
  ResultStateDb get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();

    if (_favorites.isNotEmpty) {
      _state = ResultStateDb.hasData;
    } else {
      _state = ResultStateDb.noData;
      _message = 'Data Favorit masih kosong';
    }

    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultStateDb.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ResultStateDb.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void existFavorites() async {
    _favorites = await databaseHelper.getFavorites();

    if (_favorites.isNotEmpty) {
      _state = ResultStateDb.hasData;
    } else {
      _state = ResultStateDb.noData;
      _message = 'Data Favorit masih kosong';
    }

    notifyListeners();
  }
}