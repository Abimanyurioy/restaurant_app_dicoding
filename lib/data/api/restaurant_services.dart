import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:restaurants_app/data/models/restaurant_list.dart';
import 'package:restaurants_app/data/models/restaurant_detail.dart';
import 'package:restaurants_app/data/models/restaurant_search.dart';

class ApiService {

  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListModel> getRestaurantList() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<PostReviewModel> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return PostReviewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed post data');
    }
  }

  Future<RestaurantSearchModel> getRestaurantSearch(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantSearchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}