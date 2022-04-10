/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-07 19:09:19
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-10 12:33:45
 */
import 'package:flutter/material.dart';

import '../globals.dart';

abstract class MobileBasePage extends StatefulWidget {
  MobileBasePage({Key? key, required this.pageName, this.backgroundColor})
      : super(key: key);
  String? pageName;
  Color? backgroundColor;

  @override
  MobileBasePageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  MobileBasePageState getState();
}

class MobileBasePageState<T extends MobileBasePage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            gradient: widget.backgroundColor == null
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                        0.0,
                        1.0
                      ],
                    colors: [
                        Color.fromARGB(255, 223, 211, 195),
                        Color.fromARGB(255, 240, 236, 227)
                      ])
                : null),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: widget.pageName != null
                ? Text(
                    widget.pageName!,
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
                  size: leftBackIconSize,
                  color: Color.fromARGB(255, 78, 63, 63),
                )),
          ),
          body: baseBuild(context),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }
}
