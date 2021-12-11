import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarbiyat/services/utlities.dart';

Future<void> createNot() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: createUniqueId(),
    channelKey: 'basic_channel',
    title: '${Emojis.building_kaaba} Reminder to fill your Tarbiyat details',
    body:
        'Perseverence is key to shaping Akhlaaq. Don\'t forget to fill the details of tarbiyat now!',
    notificationLayout: NotificationLayout.Messaging,
  ));
}

Future<void> createSched(NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title:
            '${Emojis.building_kaaba} Reminder to fill your Tarbiyat details',
        body:
            'Perseverence is key to shaping Akhlaaq. Don\'t forget to fill the details of tarbiyat now!',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done')
      ],
      schedule: NotificationCalendar(
        weekday: notificationSchedule.dayOfTheWeek,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ));
}

Future<void> cancelSched() async {
  await AwesomeNotifications().cancelAllSchedules();
}
