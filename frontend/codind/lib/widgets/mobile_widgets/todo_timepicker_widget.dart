/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-08 21:31:53
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-08 21:46:05
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: paddingSize),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          decoration: BoxDecoration(
            // color: Colors.blue[500]!,
            border: Border.all(color: Colors.blue[500]!),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            selectedTime,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.21),
        ),
        Container(
          margin: EdgeInsets.only(right: paddingSize),
          // width: MediaQuery.of(context).size.width * 0.21,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.blue[500]!, Colors.blue[700]!]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () async {
              var res = await Navigator.of(context).push(
                showPicker(
                    context: context,
                    value: _time,
                    onChange: onTimeChanged,
                    cancelText:
                        FlutterI18n.translate(context, "button.label.cancel"),
                    okText: FlutterI18n.translate(context, "button.label.ok")),
              );
              if (res != null) {
                setState(() {
                  int hour = (res as TimeOfDay).hour;
                  int min = res.minute;
                  var minstr = min.toString();
                  if (min < 10) {
                    minstr = "0" + minstr;
                  }

                  selectedTime = hour.toString() + " : " + minstr;
                });
              }
            },
            child: Text(
              // FlutterI18n.translate(context, "button.label.ok"),
              widget.buttonStr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }
}
