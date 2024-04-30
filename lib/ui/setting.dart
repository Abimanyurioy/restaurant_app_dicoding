import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:restaurants_app/provider/restaurant_preferences_provider.dart';
import 'package:restaurants_app/provider/restaurant_scheduling_provider.dart';

class RestaurantSettingPage extends StatelessWidget {
  const RestaurantSettingPage({super.key});

  void showDialogPermissionIsPermanentlyDenied(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Izinkan aplikasi untuk tampilkan notifikasi'),
        content: const Text(
            'Anda perlu memberikan izin ini dari pengaturan sistem.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Buka pengaturan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreferencesProvider>(
        builder: (_, preferences, __) {
          return Consumer<SchedulingProvider>(
            builder: (_, scheduled, __) {
              void setReminder(bool value) {
                scheduled.scheduledReminder(value);
                preferences.enableDailyReminder(value);
              }

              return SwitchListTile(
                title: const Text('Daily Reminder'),
                value: preferences.isDailyReminderActive,
                onChanged: (value) async {
                  if (value == true) {

                    final status = await Permission.notification.status;
                    if (status == PermissionStatus.granted) {
                      setReminder(value);
                    } else if (status == PermissionStatus.denied) {
                      final result = await Permission.notification.request();
                      if (result == PermissionStatus.granted) {
                        setReminder(value);
                      } else if (result ==
                          PermissionStatus.permanentlyDenied) {
                        if (context.mounted) {
                          showDialogPermissionIsPermanentlyDenied(context);
                        }
                      }
                    }
                  } else {
                    setReminder(value);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}