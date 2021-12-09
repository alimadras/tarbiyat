import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createNot() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 4,
    channelKey: 'basic_channel',
    title: '${Emojis.building_kaaba} Reminder to fill your Tarbiyat details',
    body:
        'Perseverence is key to shaping Akhlaaq. Don\'t forget to fill the details of tarbiyat now!',
    notificationLayout: NotificationLayout.Messaging,
  ));
}
