import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/provider/restaurant_search_provider.dart';
import 'package:restaurants_app/widgets/card_list.dart';
import 'package:restaurants_app/widgets/message.dart';
import 'package:restaurants_app/widgets/loading_progress.dart';
import 'package:restaurants_app/utils/theme.dart';

class RestaurantSearchPage extends StatelessWidget {
  static const String routeName = '/restaurant_search';

  const RestaurantSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantSearchProvider(apiService: ApiService(http.Client())),
      builder: (context, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon:  const Icon(
                Icons.keyboard_backspace,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text("Restaurant Search",
                style: whiteTextStyle.copyWith(
                  fontSize: 21,
                )),
            elevation: 0.0,
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                    hintText: 'Search by name',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  onSubmitted: (query) {
                    if (query != '') {
                      Provider.of<RestaurantSearchProvider>(
                        context,
                        listen: false,
                      ).fetchSearchRestaurant(query);
                    }
                  },
                ),
              ),
              Expanded(
                child: Consumer<RestaurantSearchProvider>(
                  builder: (_, provider, __) {
                    switch (provider.state) {
                      case ResultState.loading:
                        return const LoadingProgress();
                      case ResultState.hasData:
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: provider.result.restaurants.length,
                          itemBuilder: (_, index) {
                            final restaurant =
                            provider.result.restaurants[index];
                            return CardList(restaurant: restaurant);
                          },
                        );
                      case ResultState.noData:
                        return const Message(
                          image: 'assets/images/no-data.png',
                          message: 'Oopss... Pencarian tidak ditemukan',
                        );
                      case ResultState.error:
                        return const Message(
                          image: 'assets/images/no-connection.png',
                          message: 'Koneksi Terputus',
                        );
                      default:
                        return const Message(
                          image: 'assets/images/search.png',
                          message: 'Silahkan lakukan pencarian...',
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}