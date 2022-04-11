import 'package:flutter/material.dart';

mixin BackgroundColorMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
            0.0,
            1.0
          ],
              colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
          ])),
      child: baseBackgroundBuild(context),
    );
  }

  baseBackgroundBuild(BuildContext context) {}
}
