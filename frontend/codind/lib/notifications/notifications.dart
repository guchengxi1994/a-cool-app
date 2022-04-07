import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:codind/notifications/notification_utils.dart';

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
    NotificationWeekAndTime notification) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 21,
          channelKey: "scheduled_channel",
          title: "scheduled notification",
          body: "see~",
          notificationLayout: NotificationLayout.Default),
      actionButtons: [
        NotificationActionButton(key: "Mark_done", label: "Mark Done")
      ],
      schedule: NotificationCalendar(
        weekday: notification.dayOfTheWeek,
        hour: notification.timeOfDay.hour,
        minute: notification.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ));
}

Future<void> cancelScheduleNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}
