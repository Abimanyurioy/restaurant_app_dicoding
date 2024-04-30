import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:restaurants_app/data/models/restaurant_list.dart';
import 'package:restaurants_app/utils/theme.dart';
import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/provider/restaurant_favorite_provider.dart';
import 'package:restaurants_app/provider/restaurant_detail_provider.dart';
import 'package:restaurants_app/widgets/message.dart';
import 'package:restaurants_app/widgets/contain_restaurant.dart';
import 'package:restaurants_app/widgets/loading_progress.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(
            apiService: ApiService(http.Client()),
            restaurantId: restaurant.id,
          ),
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: heightScreen * 0.4,
                width: widthScreen,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Consumer<RestaurantDetailProvider>(
                builder: (_, provider, __) {
                  switch (provider.state) {
                    case ResultState.loading:
                      return const LoadingProgress();
                    case ResultState.hasData:
                      return ContentRestaurant(
                        provider: provider,
                        restaurant: provider.result.restaurant,
                      );
                    case ResultState.error:
                      return Message(
                        image: 'assets/images/no-connection.png',
                        message: 'Koneksi Terputus',
                        onPressed: () =>
                            provider.fetchDetailRestaurant(restaurant.id),
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, _) {
          return Container(
            height: 70,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: greyColor),
                  ),
                  child: Consumer<RestaurantFavoriteProvider>(
                    builder: (_, databaseProvider, __) {
                      return FutureBuilder<bool>(
                        future: databaseProvider.isFavorited(restaurant.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              bool isFavorited = snapshot.data ?? false;
                              return IconButton(
                                onPressed: () {
                                  if (isFavorited) {
                                    databaseProvider.removeFavorite(restaurant.id);
                                  } else {
                                    databaseProvider.addFavorite(
                                      Restaurant(
                                        id: restaurant.id,
                                        name: restaurant.name,
                                        description: restaurant.description,
                                        city: restaurant.city,
                                        pictureId: restaurant.pictureId,
                                        rating: restaurant.rating,
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showReviewModal(context, provider);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Review Restaurant',
                        style: whiteTextStyle.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon:  const Icon(
          Icons.keyboard_backspace,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text("Restaurant Detail",
          style: whiteTextStyle.copyWith(
            fontSize: 21,
          )),
      elevation: 0.0,
    );
  }

  void _showReviewModal(BuildContext context, RestaurantDetailProvider provider) {
    TextEditingController nameController = TextEditingController();
    TextEditingController reviewController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Review Restaurant',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Your Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: reviewController,
                      decoration: const InputDecoration(
                        hintText: 'Your Review',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Review cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String restaurantId =
                                  provider.result.restaurant.id;

                              String name = nameController.text;
                              String review = reviewController.text;

                              provider
                                  .postReview(
                                  id: restaurantId, name: name, review: review)
                                  .then((resultState) {
                                if (resultState == ResultState.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Review submitted successfully'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to submit review'),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}