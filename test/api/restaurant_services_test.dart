import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/data/models/restaurant_detail.dart';
import 'package:restaurants_app/data/models/restaurant_list.dart';
import 'package:restaurants_app/data/models/restaurant_search.dart';
import 'restaurant_services_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  const String getFetchAllRestaurantResponse = '''
  {
    "error": false,
    "message": "success",
    "count": 2,
    "restaurants": [
      {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
        "pictureId": "14",
        "city": "Medan",
        "rating": 4.2
      },
      {
        "id": "s1knt6za9kkfw1e867",
        "name": "Kafe Kita",
        "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
        "pictureId": "25",
        "city": "Gorontalo",
        "rating": 4
      }
    ]
  }
  ''';

  const String getSearchRestaurantResponse = '''
  {
    "error": false,
    "founded": 1,
    "restaurants": [
      {
        "id": "s1knt6za9kkfw1e867",
        "name": "Kafe Kita",
        "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
        "pictureId": "25",
        "city": "Gorontalo",
        "rating": 4
      }
    ]
  }
  ''';

  const String getDetailRestaurantResponse = '''
  {
    "error": false,
    "message": "success",
    "restaurant": {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
      "city": "Medan",
      "address": "Jln. Pandeglang no 19",
      "pictureId": "14",
      "categories": [
        {
          "name": "Italia"
        },
        {
          "name": "Modern"
        }
      ],
      "menus": {
        "foods": [
          {
            "name": "Paket rosemary"
          },
          {
            "name": "Toastie salmon"
          }
        ],
        "drinks": [
          {
            "name": "Es krim"
          },
          {
            "name": "Sirup"
          }
        ]
      },
      "rating": 4.2,
      "customerReviews": [
        {
          "name": "Ahmad",
          "review": "Tidak rekomendasi untuk pelajar!",
          "date": "13 November 2019"
        }
      ]
    }
  }
  ''';

  const String getReviewRestaurantResponse = '''
  {
    "error": false,
    "message": "success",
    "customerReviews": [
      {
        "name": "John Doe",
        "review": "Great restaurant!",
        "date": "30 April 2024"
      }
    ]
  }
  ''';

  group('Test Restaurant API', () {
    final MockClient client = MockClient();
    final ApiService apiService = ApiService(client);

    test('verify json parsing fetch all restaurant', () async {
      when(client.get(Uri.parse('${ApiService.baseUrl}/list'))).thenAnswer(
              (_) async => http.Response(getFetchAllRestaurantResponse, 200));

      expect(await apiService.getRestaurantList(), isA<RestaurantListModel>());
    });

    test('verify json parsing detail restaurant by id', () async {
      const String id = 'rqdv5juczeskfw1e867';

      when(client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')))
          .thenAnswer(
              (_) async => http.Response(getDetailRestaurantResponse, 200));

      expect(
        await apiService.getRestaurantDetail(id),
        isA<RestaurantDetailModel>(),
      );
    });

    test('getDetailRestaurantResponse throws Exception on failure', () async {
      const String id = '123';

      when(client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')))
          .thenThrow(Exception('Failed to load data'));

      expect(
            () async => await apiService.getRestaurantDetail(id),
        throwsException,
      );
    });

    test('verify json parsing search restaurant by name', () async {
      const String name = 'Kafe Kita';

      when(client.get(Uri.parse('${ApiService.baseUrl}/search?q=$name')))
          .thenAnswer(
              (_) async => http.Response(getSearchRestaurantResponse, 200));

      expect(
        await apiService.getRestaurantSearch(name),
        isA<RestaurantSearchModel>(),
      );
    });

    test('getSearchRestaurantResponse throws Exception on failure', () async {
      const String name = 'asal-asalan';

      when(client.get(Uri.parse('${ApiService.baseUrl}/search?q=$name')))
          .thenThrow(Exception('Failed to load data'));

      expect(
            () async => await apiService.getRestaurantSearch(name),
        throwsException,
      );
    });


    test('postReview returns PostReviewModel on success', () async {
      final response = http.Response(getReviewRestaurantResponse, 201);
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => response);

      final result = await apiService.postReview(
        id: '123',
        name: 'John Doe',
        review: 'Great restaurant!',
      );

      expect(result, isA<PostReviewModel>());
    });
  });
}