import 'dart:ui';
import 'package:fcm_notifications/screen1.dart';
import 'package:fcm_notifications/screen2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
  if (kDebugMode) {
    print('background clicked');
  }
}

final localNotifications = FlutterLocalNotificationsPlugin();

class LocalNotification {
   Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    LinuxInitializationSettings initializationSettingsLinux =
        const LinuxInitializationSettings(
            defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            linux: initializationSettingsLinux);

    await localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notificationResponse) async {

      if (notificationResponse.payload == 'sticky note.') {
        Get.to(() => const Screen1View());
      } else {
        Get.to(() => const Screen2View());
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  // this function is applicable to iOS versions older than 10.
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}
}

Future<void> showLocalNotification({
  required int id,
  required String title,
  required String body,
  required String payload,
}) async {
  final platformChannelSpecifics = await _notificationDetails();
  await localNotifications.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: payload,
  );
}

Future<NotificationDetails> _notificationDetails() async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true,
    groupKey: 'com.example.flutter_push_notifications',
    channelDescription: 'channel description',
    priority: Priority.max,
    icon: 'app_icon',
    ticker: 'ticker',
    color: Color(0xff2196f3),
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      playSound: true);

  await localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails(threadIdentifier: "thread1");

  final details = await localNotifications.getNotificationAppLaunchDetails();
  if (details != null && details.didNotificationLaunchApp) {}
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

  return platformChannelSpecifics;
}
