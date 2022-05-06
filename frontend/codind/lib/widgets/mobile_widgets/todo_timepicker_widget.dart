// ignore_for_file: must_be_immutable, prefer_const_constructors

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-08 21:31:53
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-11 21:10:48
 */

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class TodoTimepickerWidget extends StatefulWidget {
  TodoTimepickerWidget({Key? key, required this.buttonStr}) : super(key: key);
  String buttonStr;

  @override
  State<TodoTimepickerWidget> createState() => TodoTimepickerWidgetState();
}

class TodoTimepickerWidgetState extends State<TodoTimepickerWidget> {
  late TimeOfDay _time;
  final paddingSize = 20.0;
  String selectedTime = "";

  TimeOfDay get time => _time;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay.now();
    formatDaytime(_time);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.buttonStr,
            style: TextStyle(
              color: Colors.blue[700]!,
              fontSize: 20,
            ),
          ),
          TextButton(
              onPressed: () async {
                var res = await Navigator.of(context).push(
                  showPicker(
                      context: context,
                      value: _time,
                      onChange: onTimeChanged,
                      cancelText:
                          FlutterI18n.translate(context, "button.label.cancel"),
                      okText:
                          FlutterI18n.translate(context, "button.label.ok")),
                );
                if (res != null) {
                  setState(() {
                    formatDaytime(res);
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[700]!, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  selectedTime,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ))
        ],
      ),
    );
  }

  void formatDaytime(TimeOfDay res) {
    int hour = (res).hour;
    int min = res.minute;
    var minstr = min.toString();
    if (min < 10) {
      minstr = "0" + minstr;
    }

    selectedTime = hour.toString() + " : " + minstr;
  }
}
