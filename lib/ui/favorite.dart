import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:restaurants_app/provider/restaurant_favorite_provider.dart';
import 'package:restaurants_app/widgets/card_list.dart';
import 'package:restaurants_app/widgets/message.dart';

class RestaurantFavoritePage extends StatelessWidget {
  static const routeName = '/restaurant_favorite';

  const RestaurantFavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<RestaurantFavoriteProvider>(
      builder: (_, provider, __) {
        if (provider.state == ResultStateDb.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            itemCount: provider.favorites.length,
            itemBuilder: (_, index) {
              final restaurant = provider.favorites[index];
              return CardList(restaurant: restaurant);
            },
          );
        } else {
          return Message(
            image: 'assets/images/no-data.png',
            message: provider.message,
          );
        }
      },
    );
  }
}