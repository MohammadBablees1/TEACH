import 'package:awesome_notifications/awesome_notifications.dart';

class RequestNotification {

    Future<void> requestNotificationPermission() async {
    final isAllowed =
        await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //   await showNotification(message);
  // });
    }
  }
}