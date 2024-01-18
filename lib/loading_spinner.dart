import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final Color color;
  final double size;

  const LoadingSpinner({Key? key, required this.color, this.size = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Platform.isIOS
          ? CupertinoActivityIndicator(
        radius: 10,
        color: color,
      )
          : CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
