import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetracker_mobile/mobile/settings/settings_widget.dart';
import 'package:timetracker_mobile/shared/providers/settings_provider.dart';
import 'package:timetracker_mobile/shared/providers/timetracker_provider.dart';
import 'add_new_entry/add_new_entry_widget.dart';
import 'home_page/home_page_widget.dart';
import 'package:timetracker_mobile/shared/notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

String initialRoute = HomePageWidget.routeName;

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void runMobileApp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = AddNewEntryWidget.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeTrackerProvider(prefs)),
      ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
    ],
    child: MaterialApp(
      title: 'BairesDev TimeTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        HomePageWidget.routeName: (_) =>
            HomePageWidget(notificationAppLaunchDetails),
        AddNewEntryWidget.routeName: (_) =>
            AddNewEntryWidget(selectedNotificationPayload),
        SettingsWidget.routeName: (_) => SettingsWidget()
      },
    ),
  ));
}
