import 'package:flutter/material.dart';

import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/data/models/restaurant_list.dart';


enum ResultState { loading, noData, hasData, error }

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    fetchAllRestaurant();
  }

  late RestaurantListModel _restaurantListModel;
  late ResultState _state;
  String _message = '';

  RestaurantListModel get result => _restaurantListModel;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurantList = await apiService.getRestaurantList();
      if (restaurantList.count == 0 && restaurantList.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();

        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();

        return _restaurantListModel = restaurantList;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}