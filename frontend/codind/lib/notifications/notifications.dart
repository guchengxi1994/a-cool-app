import 'package:awesome_notifications/awesome_notifications.dart';

import '../entity/entity.dart' show ScheduleNotificationEntity;

Future<void> createBasicNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: 'basic_channel',
    title: 'Simple Notification',
    body: 'Simple body',
  ));
}

Future<void> createReminderNotivication(
    ScheduleNotificationEntity notification) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: notification.notificationId,
          channelKey: "scheduled_channel",
          title: notification.title,
          body: notification.subTitle,
          notificationLayout: NotificationLayout.Default),
      actionButtons: [NotificationActionButton(key: "OK", label: "OK")],
      schedule: NotificationCalendar(
        hour: notification.timeOfDay.hour,
        minute: notification.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: notification.isRepeat,
      ));
}

Future<void> cancelAllScheduleNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

Future<void> cancelScheduleNotifications(int id) async {
  await AwesomeNotifications().cancel(id);
}
