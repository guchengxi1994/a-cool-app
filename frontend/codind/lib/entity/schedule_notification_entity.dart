import 'package:flutter/material.dart';

class ScheduleNotificationEntity {
  int notificationId;
  String title;

  /// body
  String? subTitle;

  int? dayOfTheWeek;
  TimeOfDay timeOfDay;
  bool isRepeat;
  bool? isDone;

  ScheduleNotificationEntity(
      {required this.notificationId,
      required this.title,
      this.subTitle,
      this.dayOfTheWeek,
      required this.timeOfDay,
      required this.isRepeat,
      this.isDone = false});
}
