import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juma_samsa/home_screen.dart';
import 'package:juma_samsa/login_screen.dart';
import 'package:juma_samsa/not_friday_screen.dart';
import 'package:juma_samsa/order_placed_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('id') ?? '';
  String login = prefs.getString('login') ?? '';
  int timestamp = prefs.getInt('timestamp') ?? 0;
  int count = prefs.getInt('count') ?? 0;

  runApp(MyApp(
    id: id,
    login: login,
    timestamp: timestamp,
    count: count,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.id,
      required this.login,
      required this.timestamp,
      required this.count});

  final String id;
  final String login;
  final int timestamp;
  final int count;

  @override
  Widget build(BuildContext context) {
    bool orderedRecently = false;
    if (timestamp != 0) {
      int timestamp1 = timestamp; // Timestamp for a particular date and time
      int timestamp2 =
          DateTime.now().millisecondsSinceEpoch; // Current timestamp

      // Convert the timestamps to DateTime objects
      DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
      DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(timestamp2);

      // Calculate the time difference
      Duration difference = dateTime2.difference(dateTime1);

      if (difference.inHours < 24) {
        orderedRecently = true;
      }
      print(difference.inHours);
    }

    DateTime today = DateTime.now();

    // Get the weekday (1 for Monday, 2 for Tuesday, ..., 7 for Sunday)
    int weekday = today.weekday;
    int hours = today.hour;

    return MaterialApp(
      title: 'Juma Samsa',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: //NotFridayScreen()
          weekday == 5 && hours < 14
              ? id.length > 10
                  ? orderedRecently
                      ? OrderPlacedScreen(count: count)
                      : HomeScreen(userId: id, login: login)
                  : LoginScreen()
              : NotFridayScreen(),
    );
  }
}
