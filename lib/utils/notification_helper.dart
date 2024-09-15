import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null) {
        developer.log('notification payload: $payload');
        selectNotificationSubject.add(payload);
      } else {
        selectNotificationSubject.add('empty payload');
      }
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      WelcomeList restaurants) async {
    const String channelId = "1";
    const String channelName = "resto_01";
    const String channelDescription = "Menampilkan restoran";

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    const String titleNotification = "<b>Restoran hari ini</b>";
    // final String titleRestaurants = restaurants.restaurants[0].name;

    final random = math.Random();
    final randomIndex = random.nextInt(restaurants.restaurants.length);
    final String titleRestaurants = restaurants.restaurants[randomIndex].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleRestaurants,
      platformChannelSpecifics,
      payload: json.encode(restaurants.toJson()),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = WelcomeList.fromJson(json.decode(payload));
        var restaurant = data.restaurants[0];
        Navigation.intentWithData(route, restaurant);
      },
    );
  }
}
