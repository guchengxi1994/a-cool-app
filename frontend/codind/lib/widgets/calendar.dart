/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-13 22:10:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-13 23:03:54
 */

/// diy a scroll bar  https://www.jianshu.com/p/c14c5bd649c2

import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List days = List.generate(365, (e) => e);
    Map<String, int> data = {
      "title": 31,
      "1": 31,
      "2": 28,
      "3": 31,
      "4": 30,
      "5": 31,
      "6": 30,
      "7": 31,
      "8": 31,
      "9": 30,
      "10": 31,
      "11": 30,
      "12": 31,
    };

    List _days = data.values.toList();
    print(_days);
    // var _l = List.generate(31, (i) => i);
    return Scaffold(
      // body: SingleChildScrollView(
      //     key: UniqueKey(),
      //     scrollDirection: Axis.horizontal,
      //     primary: true,
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: _l.map((e) {
      //         return Container(
      //           margin: const EdgeInsets.all(5),
      //           height: 20,
      //           width: 20,
      //           color: Colors.red,
      //         );
      //       }).toList(),
      //     )),
      // body: Wrap(
      //   spacing: 5,
      //   runSpacing: 5,
      //   children: days.map((e) {
      //     return Container(
      //       height: 20,
      //       width: 20,
      //       color: Colors.red,
      //     );
      //   }).toList(),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _days
            .asMap()
            .map((key, value) {
              var _l = List.generate(value, (i) => i);
              if (key == 0) {
                return MapEntry(
                    key,
                    SingleChildScrollView(
                      controller: scrollController,
                      key: UniqueKey(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _l.map((e) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            child: Text((e + 1).toString()),
                            color: const Color.fromARGB(255, 175, 147, 145),
                          );
                        }).toList(),
                      ),
                    ));
              }
              return MapEntry(
                  key,
                  SingleChildScrollView(
                    key: UniqueKey(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _l.map((e) {
                        return Container(
                          margin: const EdgeInsets.all(5),
                          height: 20,
                          width: 20,
                          color: Colors.red,
                        );
                      }).toList(),
                    ),
                  ));
            })
            .values
            .toList(),
      ),
    );
  }
}
