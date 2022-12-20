import 'package:fcm_notifications/notification_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  //
  // showLocalNotification(
  //     id: 1,
  //     title: message.notification?.title ?? '',
  //     body: message.notification?.body ?? '',
  //     payload: message.notification?.title ?? '');
}

class FCMNotificationHelper {
  static void registerNotification() async {
    await Firebase.initializeApp();
    LocalNotification service = LocalNotification();
    service.initializeLocalNotifications();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      if (kDebugMode) {
        print(value);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('************ getInitialMessage *****************');
        Get.showSnackbar(GetSnackBar(title: 'getInitialMessage',message: message.notification?.body ?? '',));
      }
    });

    NotificationSettings settings = await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //   print('new messages on opened app');
        // showLocalNotification(
        //     id: 1,
        //     title: message.notification?.title ?? '',
        //     body: 'It is from onMessageOpenedApp',
        //     payload: message.notification?.title ?? '');
        //   // Parse the message received
        //

        print(message.notification?.title ?? '');
        Get.showSnackbar(GetSnackBar(title: 'onMessageOpenedApp',message: message.notification?.body ?? '',));
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showLocalNotification(
            id: 1,
            title: message.notification?.title ?? '',
            body: message.notification?.body ?? '',
            payload: message.notification?.title ?? '');
        // Parse the message received
      });
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
}
