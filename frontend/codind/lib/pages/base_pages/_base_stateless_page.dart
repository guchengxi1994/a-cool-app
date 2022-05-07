import 'package:flutter/material.dart';

import '../../_styles.dart';

// ignore: must_be_immutable
abstract class BaseStatelessPage extends StatelessWidget {
  BaseStatelessPage({Key? key, this.pageName, this.backgroundColor})
      : super(key: key);
  String? pageName;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            gradient: backgroundColor == null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: AppTheme.baseBackgroundColors)
                : null),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppTheme.baseAppbarColor,
            elevation: 0,
            title: pageName != null
                ? Text(
                    pageName!,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                : null,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: AppTheme.leftBackIconSize,
                  color: Color.fromARGB(255, 78, 63, 63),
                )),
          ),
          body: baseBuild(context),
        ),
      ),
    );
  }

  baseBuild(BuildContext context) {}
}
