import 'package:flutter/material.dart';

class NotFridayScreen extends StatelessWidget {
  const NotFridayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.snooze_outlined,
                color: Colors.purple,
                size: 100,
              ),
              SizedBox(height: 30),
              Text(
                'Біз тек жұма сағат 14:00ге дейін жұмыс жасаймыз',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Colors.purple, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
