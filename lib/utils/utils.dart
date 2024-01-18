import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io' show Platform;

import '../loading_spinner.dart';

void pushScreen(context, Widget screen,
    {PageTransitionType transitionType =
        PageTransitionType.rightToLeftWithFade}) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  } else {
    Navigator.push(
        context,
        PageTransition(
          child: screen,
          duration: const Duration(milliseconds: 250),
          type: transitionType,
        ));
  }
}

void pushReplacementScreen(context, Widget screen,
    {PageTransitionType transitionType = PageTransitionType.bottomToTop}) {
  if (Platform.isIOS) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  } else {
    Navigator.pushReplacement(
        context,
        PageTransition(
          child: screen,
          duration: const Duration(milliseconds: 250),
          type: transitionType,
        ));
  }
}

void bottomToast({String text = 'toast'}) {
  BotToast.showText(
    text: text,
    contentColor: Colors.black.withOpacity(0.5),
    textStyle: TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
    crossPage: true,
  );
}

void centerToast({required String text}) {
  BotToast.showText(
    text: text,
    align: Alignment.center,
    wrapToastAnimation: (controller, offset, child) {
      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      );
    },
    contentColor: Colors.black.withOpacity(0.5),
    textStyle: TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
    crossPage: true,
  );
}

void startScreenLoading() {
  BotToast.showCustomLoading(toastBuilder: (void Function() cancelFunc) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: LoadingSpinner(
        size: 30,
        color: Colors.purple,
      ),
    );
  });
}

void stopScreenLoading() => BotToast.cleanAll();
