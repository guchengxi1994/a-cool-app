// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../_styles.dart';

// ignore: must_be_immutable
class CoolExpandedWidget extends StatelessWidget {
  CoolExpandedWidget(
      {Key? key, required this.child, this.mainColor, this.reversed = false})
      : super(key: key);
  Widget child;
  Color? mainColor;
  bool? reversed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            color: mainColor ?? AppTheme.white,
            borderRadius: !reversed!
                ? BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(68.0))
                : BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(top: 60, left: 10, right: 10, bottom: 10),
            child: child,
          ),
        ));
  }
}
