import 'package:flutter/material.dart';

Future pushWithoutAnimation(BuildContext context, Widget page) {
  return Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration(seconds: 0),
    reverseTransitionDuration: Duration(seconds: 0),
  ));
}

Future pushReplacementWithoutAnimation(BuildContext context, Widget page) {
  return Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration(seconds: 0),
    reverseTransitionDuration: Duration(seconds: 0),
  ));
}
