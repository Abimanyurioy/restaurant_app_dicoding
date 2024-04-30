import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:restaurants_app/utils/theme.dart';
import 'package:restaurants_app/data/models/restaurant_list.dart';
import 'package:restaurants_app/ui/detail.dart';

class CardList extends StatelessWidget {
  final Restaurant restaurant;

  const CardList({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RestaurantDetailPage.routeName,
            arguments: restaurant,
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                      'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    Container(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 5),
                          Text(
                            restaurant.name ?? '',
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${restaurant.city ?? ''}',
                                style: greyTextStyle.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Container(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.rating != null
                                    ? '${restaurant.rating}'
                                    : '0',
                                style: greyTextStyle.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Container(height: 6),
                          Text(
                            restaurant.description ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: greyTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}