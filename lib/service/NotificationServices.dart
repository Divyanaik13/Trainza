import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:club_runner/util/local_storage/LocalStorage.dart';
import 'package:club_runner/view/main_page/MainScreen.dart';
import 'package:club_runner/view/welcome_screen/WelcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../util/FunctionConstant/FunctionConstant.dart';
import '../main.dart';
import '../models/NotificationPayload_Model.dart';
import '../util/const_value/ConstValue.dart';
import '../view/splash_screen/SplashScreen.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static LocalStorage sp = LocalStorage();

  static NotificationPayloadModel? notificationPayloadModel;
  static var settings;
  static var duplicateNotification = "";

  Future<String?> getToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  Future initialize() async {
    // Get the token
    try {
      settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      var token = await getToken();
      var deviceId = await CommonFunction.getDeviceId();
      print("Token :-- $token");
      print("Device Id :-- ${deviceId}");

      if (token != null) {
        LocalStorage.setStringValue(sp.deviceToken, token.toString());
      }
      if (deviceId != null) {
        LocalStorage.setStringValue(sp.deviceId, deviceId.toString());
      }
    } catch (e) {
      log("Exception in notification service initialize :-- ",
          error: e.toString());
    }
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print(
        'Handling a background message ${message.data["notificationPayload"]}');
  }

  static void localNotification(BuildContext context) async {
    try {
      //For Local Notification...
      AndroidInitializationSettings androidSettings =
          const AndroidInitializationSettings('@mipmap/app_icon');

      DarwinInitializationSettings darwinIOSSettings =
          const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      InitializationSettings initializationSettings = InitializationSettings(
          android: androidSettings, iOS: darwinIOSSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
      log('LocalNotifications Initialized');
      NotificationService.notificationClickAndIncoming();
    } catch (e) {
      log("Exception in notification service :-- ", error: e.toString());
    }
  }

  static notificationClickAndIncoming() {
    try {
      //For incoming message..
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!${message.data}');
        NotificationService.showLocalNotification(
            flutterLocalNotificationsPlugin,
            message,
            message.notification?.title,
            message.notification?.body);
     /* if(duplicateNotification.toString() != message.data['notification_id'].toString()){
          duplicateNotification = message.data['notification_id'];
          NotificationService.showLocalNotification(
              flutterLocalNotificationsPlugin,
              message,
              message.notification?.title,
              message.notification?.body);
        }*/

        // NotificationService.notificationPayloadModel = notificationPayloadModelFromJson(jsonEncode(message.data));

        // print("notificationPayload :-- ${ notificationPayloadModelFromJson(message.data["notificationPayload"])}");
      });

      //Handling a notification click event when the app is in the kill state
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print('instance kill state :  ${message}');
          NotificationService.notificationPayloadModel =
              notificationPayloadModelFromJson(jsonEncode(message.data));

          if (LocalStorage.getStringValue(sp.authToken).isNotEmpty) {
            ConstValue.isFromNotification = true;
            Navigator.pushAndRemoveUntil(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeScreen()),
                (Route<dynamic> route) => false);
          }
        }
      });

      // Handling a notification click event when the app is in the background
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        print('onMessageOpenedApp: ${message.notification!.title.toString()}');

        print('Message data onMessageOpenedApp: ${message.data}');
        if (message != null) {
          NotificationService.notificationPayloadModel =
              notificationPayloadModelFromJson(jsonEncode(message.data));

          if (LocalStorage.getStringValue(sp.authToken).isNotEmpty) {
            ConstValue.isFromNotification = true;
            Navigator.pushAndRemoveUntil(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeScreen()),
                (Route<dynamic> route) => false);
          }
        }
      });

      FirebaseMessaging.onBackgroundMessage((message) {
        print("onBackgroundMessage");
        return backgroundHandler(message);
      });
    } catch (e) {
      log("Exception in notification service notificationClickAndIncoming :-- ",
          error: e.toString());
    }
  }

  static void showLocalNotification(
      FlutterLocalNotificationsPlugin localNotifications,
      RemoteMessage message,
      String? title,
      String? body) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      "trainza",
      "com.club.runner.clubRunner",
      priority: Priority.max,
      icon: '@mipmap/app_icon',
      importance: Importance.max,
      playSound: true,
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notiDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await localNotifications.show(0, title, body, notiDetails,
        payload: jsonEncode(message.data));
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print(
        "onDidReceiveNotificationResponse pay load :----  ${notificationResponse.payload}");
    NotificationService.notificationPayloadModel = notificationPayloadModelFromJson(notificationResponse.payload!);
    print(
        'NotificationService.notificationPayloadModel ${NotificationService.notificationPayloadModel!.notificationType}');

    if (LocalStorage.getStringValue(sp.authToken).isNotEmpty) {
      ConstValue.isFromNotification = true;
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()),
          (Route<dynamic> route) => false);
    }

    /*if (message != null) {
      NotificationService.notificationPayloadModel =
          notificationPayloadModelFromJson(jsonEncode(message.data));
      ConstValue.isFromNotification = true;
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (BuildContext context) => MainScreen()),
              (Route<dynamic> route) => false);
    }*/

    /* if (notificationResponse != null) {
      NotificationService.notificationPayloadModel =
          notificationPayloadModelFromJson(notificationResponse.payload!);

      ConstValue.isFromNotification = true;

      Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
          (Route<dynamic> route) => false);
    }*/
  }
}
