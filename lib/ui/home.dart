import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurants_app/data/models/slider.dart';
import 'package:restaurants_app/utils/theme.dart';
import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/provider/restaurant_list_provider.dart';
import 'package:restaurants_app/widgets/card_list.dart';
import 'package:restaurants_app/widgets/message.dart';
import 'package:restaurants_app/widgets/loading_progress.dart';
import 'package:restaurants_app/ui/search.dart';
import 'package:restaurants_app/ui/favorite.dart';
import 'package:restaurants_app/ui/setting.dart';
class RestaurantHome extends StatelessWidget {
  static const routeName = '/restaurant_home';

  RestaurantHome({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantListProvider>(
      create: (_) => RestaurantListProvider(apiService: ApiService()),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _homePage(),
            const RestaurantFavoritePage(),
            const RestaurantSettingPage()
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.blueGrey,
          buttonBackgroundColor: Colors.white,
          color: const Color.fromARGB(255, 14, 14, 14),
          height: 65,
          items: const <Widget>[
            Icon(
              Icons.home,
              size: 35,
              color: Colors.green,
            ),
            Icon(
              Icons.favorite,
              size: 35,
              color: Colors.red,
            ),
            Icon(
              Icons.settings,
              size: 35,
              color: Colors.blue,
            )
          ],
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Restaurant App',
          style: whiteTextStyle.copyWith(
            fontSize: 21,
          )),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, RestaurantSearchPage.routeName);
          },
        ),
      ],
    );
  }


}

Widget _homePage() {
  return Consumer<RestaurantListProvider>(
      builder: (_, provider, __) {
        switch (provider.state) {
          case ResultState.loading:
            return const LoadingProgress();
          case ResultState.hasData:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: imageSliders,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cari Restaurant Indonesia',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Berikut rekomendasi dari kami',
                        style: greyTextStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.result.count,
                    itemBuilder: (_, index) {
                      final restaurant = provider.result.restaurants[index];
                      return CardList(
                          restaurant: restaurant);
                    },
                  ),
                ),
              ],
            );
          case ResultState.noData:
            return const Message(
              image: 'assets/images/no-data.png',
              message: 'Data Kosong',
            );
          case ResultState.error:
            return Message(
              image: 'assets/images/no-connection.png',
              message: 'Koneksi Terputus',
              onPressed: () => provider.fetchAllRestaurant(),
            );
          default:
            return const SizedBox();
        }
      }
  );
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(item.imgPath, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
