import 'package:flutter/material.dart';

import 'home_screen.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Тапсырыc қабылданды! \nНиет қабыл болсын! 🤲',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              Hero(
                tag: 'gif',
                child: Image.asset(
                  'assets/Samosa.gif',
                  height: 300,
                  width: 300,
                ),
              ),
              FutureBuilder<String>(
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
                        child: Column(
                          children: [
                            Text('Осы аптаға'),
                            Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 50),
                            ),
                            Text('Cізге ${widget.count}'),
                          ],
                        ),
                      ); // snapshot.data  :- get your object which is pass from your downloadData() function
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
