import 'package:flutter/material.dart';

mixin BackgroundColorMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
            0.0,
            1.0
          ],
              colors: [
            Color.fromARGB(255, 223, 211, 195),
            Color.fromARGB(200, 240, 236, 227)
          ])),
      child: baseBackgroundBuild(context),
    );
  }

  baseBackgroundBuild(BuildContext context) {}
}
