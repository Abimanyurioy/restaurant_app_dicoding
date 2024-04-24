import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:restaurants_app/utils/theme.dart';
import 'package:restaurants_app/data/models/restaurant_detail.dart';
import 'package:restaurants_app/provider/restaurant_detail_provider.dart';
import 'package:restaurants_app/widgets/card_review.dart';
import 'package:restaurants_app/provider/restaurant_favorite_provider.dart';

class ContentRestaurant extends StatelessWidget {
  final RestaurantDetail restaurant;
  final RestaurantDetailProvider provider;

  const ContentRestaurant({
    super.key,
    required this.restaurant,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    String categories = restaurant.categories!
        .map((category) => category.name ?? '')
        .join(', ');

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name ?? '',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.city ?? '',
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              RatingBarIndicator(
                rating: restaurant.rating ?? 0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Category: $categories',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Description',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            restaurant.description ?? '',
            textAlign: TextAlign.justify,
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Foods',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              children: restaurant.menus!.foods!.map((food) {
                return _itemMenu(
                  'assets/images/food.png',
                  food.name,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Drinks',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              children: restaurant.menus!.drinks!.map((drink) {
                return _itemMenu(
                  'assets/images/drink.png',
                  drink.name,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Review Restaurant',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: restaurant.customerReviews!.map((review) {
                  return ReviewCard(
                    name: review.name,
                    date: review.date,
                    review: review.review,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemMenu(String image, String? name) {
    return Container(
      height: 200,
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              height: 80,
              width: 60,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              '$name',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}