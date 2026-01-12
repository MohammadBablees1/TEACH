import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:teach/core/background_handler.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/firebase_options.dart';

class AppInitializer {
  static bool _initialized = false;

  static Future<void> initAfterLaunch() async {
    if (_initialized) return;
    _initialized = true;
  
    // Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Register background handler ONCE
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
    // Foreground messages (مرة واحدة)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
    // Hive
    await Hive.initFlutter();
    await Hive.openBox(hiveBoxName);

    // FirebaseMessaging.instance.setAutoInitEnabled(false);
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Channel for basic notifications',
          importance: NotificationImportance.High,
          defaultColor: Colors.blue,
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );
  }
}
