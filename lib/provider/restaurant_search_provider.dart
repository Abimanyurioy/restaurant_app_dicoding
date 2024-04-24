import 'package:flutter/material.dart';

import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/data/models/restaurant_search.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  late RestaurantSearchModel _restaurantSearchModel;
  ResultState? _state;
  String _message = '';

  String get message => _message;
  RestaurantSearchModel get result => _restaurantSearchModel;
  ResultState? get state => _state;

  Future<dynamic> fetchSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurantSearch = await apiService.getRestaurantSearch(query);
      if (restaurantSearch.founded == 0 &&
          restaurantSearch.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();

        return _message = 'Pencarian Tidak Ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();

        return _restaurantSearchModel = restaurantSearch;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}