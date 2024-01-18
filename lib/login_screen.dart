import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:http/http.dart';
import 'package:juma_samsa/home_screen.dart';
import 'package:juma_samsa/utils/network_client.dart';
import 'package:juma_samsa/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String login = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [Colors.purple, Colors.blue, Colors.purple];

    const colorizeTextStyle =
        TextStyle(fontSize: 50.0, fontWeight: FontWeight.w700);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'gif',
                  child: Image.asset(
                    'assets/Samosa.gif',
                    height: 200,
                    width: 200,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Juma Samsa',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Логин:',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onChanged: (String val) {
                    setState(() {
                      login = val;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    isDense: true,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Пароль:',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (String val) {
                    setState(() {
                      password = val;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    isDense: true,
                  ),
                ),
                SizedBox(height: 30),
                Bounceable(
                  onTap: login.length > 3 && password.length > 3
                      ? () async {
                          startScreenLoading();
                          Response response = await NetworkClient.post(
                              context, 'login', body: {
                            "username": login.trim(),
                            "password": password.trim()
                          });

                          if (response.statusCode == 200) {
                            print('lol');
                            print(jsonDecode(response.body)['id']);
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString(
                                'id', jsonDecode(response.body)['id']);
                            await prefs.setString('login', login);
                            stopScreenLoading();
                            if (context.mounted) {
                              pushReplacementScreen(
                                context,
                                HomeScreen(
                                  login: login,
                                  userId: jsonDecode(response.body)['id'] ?? '',
                                ),
                              );
                            }
                          } else {
                            stopScreenLoading();
                            bottomToast(text: 'Бірдеңе дұрыс болмады');
                          }
                        }
                      : null,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: login.length > 3 && password.length > 3
                          ? Colors.purple
                          : Colors.purple.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Кіру',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
