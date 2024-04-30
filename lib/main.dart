import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:restaurants_app/ui/home.dart';
import 'package:restaurants_app/ui/detail.dart';
import 'package:restaurants_app/ui/search.dart';
import 'package:restaurants_app/utils/background_service.dart';
import 'package:restaurants_app/utils/notification_helper.dart';
import 'package:restaurants_app/data/api/restaurant_services.dart';
import 'package:restaurants_app/data/db/database_helper.dart';
import 'package:restaurants_app/data/models/restaurant_list.dart';
import 'package:restaurants_app/data/preferences/preferences_helper.dart';
import 'package:restaurants_app/provider/restaurant_favorite_provider.dart';
import 'package:restaurants_app/provider/restaurant_list_provider.dart';
import 'package:restaurants_app/provider/restaurant_preferences_provider.dart';
import 'package:restaurants_app/provider/restaurant_scheduling_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantFavoriteProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(
            apiService: ApiService(http.Client()),
          ),
        ),// Provide DatabaseProvider
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Colors.black,
          ),
        ),
        initialRoute: RestaurantHome.routeName,
        routes: {
          RestaurantHome.routeName: (context) => RestaurantHome(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
          ),
          RestaurantSearchPage.routeName: (_) => const RestaurantSearchPage(),
        },
      ),
    );
  }
}
