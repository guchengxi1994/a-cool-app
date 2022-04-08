import 'package:codind/entity/schedule_notification_entity.dart'
    show ScheduleNotificationEntity;
import 'package:codind/widgets/main_page_widgets/mobile.dart';
import 'package:flutter/material.dart';

class ScheduleNotificationWidget extends StatelessWidget {
  ScheduleNotificationWidget({Key? key, required this.entity})
      : super(key: key);
  static const double fontSize = 25.0;

  ScheduleNotificationEntity entity;

  @override
  Widget build(BuildContext context) {
    return MainPageCard(
        collapsedWidget: Container(
          height: 100,
          color: entity.isDone! ? Colors.white : Colors.redAccent,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                entity.title,
                style: const TextStyle(
                    fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        expanedWidget: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(entity.title),
                Text(entity.subTitle ?? ""),
              ],
            )),
        closeIconColor: Colors.black);
  }
}
