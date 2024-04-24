import 'package:flutter/material.dart';

import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/data/models/restaurant_detail.dart';

enum ResultState { loading, noData, hasData, error, success }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId
  }) {
    fetchDetailRestaurant(restaurantId);
  }

  late RestaurantDetailModel _restaurantDetailModel;
  late ResultState _state;
  String _message = '';

  RestaurantDetailModel get result => _restaurantDetailModel;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> fetchDetailRestaurant(String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurantDetail =
      await apiService.getRestaurantDetail(restaurantId);
      _state = ResultState.hasData;
      notifyListeners();

      return _restaurantDetailModel = restaurantDetail;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final postReviewResult = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );
      if (postReviewResult.error == false &&
          postReviewResult.message == 'success') {
        fetchDetailRestaurant(id);

        return ResultState.success;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error --> $e';
    }
  }
}