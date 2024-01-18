import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:http/http.dart';
import 'package:juma_samsa/order_placed_screen.dart';
import 'package:juma_samsa/utils/network_client.dart';
import 'package:juma_samsa/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.userId, required this.login})
      : super(key: key);

  final String login;
  final String userId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'gif',
                    child: Image.asset(
                      'assets/Samosa.gif',
                      height: 300,
                      width: 300,
                    ),
                  ),
                  Text(
                    'Қош келдіңіз, ${widget.login}!',
                    style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Сіз әр жұма күні сағат 14:00ге дейін самсаға бір рет тапсырыс бере аласыз. \nP.S Кейін ақшасын каспиге салуды ұмытпа',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Bounceable(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            if (count != 1) {
                              count--;
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              '-',
                              style:
                                  TextStyle(fontSize: 50, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: TextStyle(color: Colors.purple, fontSize: 50),
                      ),
                      Bounceable(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            count++;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style:
                                  TextStyle(fontSize: 50, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Bounceable(
                    onTap: () async {
                      startScreenLoading();
                      Response response =
                          await NetworkClient.post(context, 'order', body: {
                        "user_id": widget.userId,
                        "quantity": count,
                        "date": DateTime.now().millisecondsSinceEpoch
                      });
                      stopScreenLoading();
                      if (response.statusCode == 201) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setInt(
                            'timestamp', DateTime.now().millisecondsSinceEpoch);
                        await prefs.setInt('count', count);
                        centerToast(text: 'Тапсырыс жіберілді');
                        if (context.mounted) {
                          pushReplacementScreen(
                            context,
                            OrderPlacedScreen(
                              count: count,
                            ),
                          );
                        }
                      } else {
                        bottomToast(text: 'Серверде қате!');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      height: 80,
                      child: Center(
                        child: Text(
                          'Тапсырыс беру!',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1.seconds, delay: 3.seconds),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: FutureBuilder<String>(
                future: getValue(context), // function where you call your api
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  // AsyncSnapshot<Your object type>
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(
                        'Жүктелуде...',
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Қате',
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Осы аптаға ${snapshot.data}',
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ); // snapshot.data  :- get your object which is pass from your downloadData() function
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<String> getValue(context) async {
  Response response = await NetworkClient.get(
      context, 'total?date=${DateTime.now().millisecondsSinceEpoch}');
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['total'].toString();
  } else {
    throw Exception();
  }
}
