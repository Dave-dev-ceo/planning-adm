import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:open_filex/open_filex.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// class NoticationsService {
//   static final NoticationsService _noticationsService =
//       NoticationsService._internal();

//   factory NoticationsService() {
//     return _noticationsService;
//   }
//   static final BehaviorSubject<ReceivedNotification>
//       didReceiveLocalNotificationSubject =
//       BehaviorSubject<ReceivedNotification>();

//   NoticationsService._internal();

//   static Future<void> initNotication() async {
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('ic_launcher');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false,
//             onDidReceiveLocalNotification: (
//               int id,
//               String? title,
//               String? body,
//               String? payload,
//             ) async {
//               if (payload != null) {
//                 debugPrint(payload);
//                 await OpenFilex.open(payload);
//               }
//             });

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveBackgroundNotificationResponse: (details) async {
//         final payload = details.payload;
//         if (payload != null) {
//           await OpenFilex.open(payload);
//         }
//       },
//       onDidReceiveNotificationResponse: (details) async {
//         final payload = details.payload;
//         if (payload != null) {
//           await OpenFilex.open(payload);
//         }
//       },
//     );

//     flutterLocalNotificationsPlugin
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   Future<void> showNotification(
//     int id,
//     String title,
//     Map<String, dynamic> body,
//     int seconds,
//   ) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body['message'],
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'main_channel',
//           'Main channel',
//           channelDescription: 'Canal principal',
//           priority: Priority.max,
//           importance: Importance.max,
//           icon: '@mipmap/ic_launcher',
//           playSound: true,
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'default.wav',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//       payload: body['filePath'],
//     );
//   }
// }

class NotificacionServicio {
  static late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  static late AndroidNotificationDetails androidDetails;
  static late DarwinNotificationDetails darwinDetails;

  static init() async {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupAndroidDetails();
    _setupDarwinDetails();
    _setupNotifications();
  }

  static void _setupAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'main_channel',
      'main_channel',
      channelDescription: 'Canal de notificaciones',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  static void _setupDarwinDetails() {
    darwinDetails = const DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  }

  static void _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  static Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static _initializeNotifications() async {
    const android = AndroidInitializationSettings('splash');
    // Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
      InitializationSettings(
          android: android,
          iOS: DarwinInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
              onDidReceiveLocalNotification: (
                int id,
                String? title,
                String? body,
                String? payload,
              ) async {
                if (payload != null) {
                  debugPrint(payload);
                  await OpenFilex.open(payload);
                }
              })),
      onDidReceiveBackgroundNotificationResponse: _onDidReceiveNotificacion,
      onDidReceiveNotificationResponse: _onDidReceiveNotificacion,
    );
  }

  static void _onDidReceiveNotificacion(NotificationResponse details) async {
    final payload = details.payload;
    if (payload != null) {
      await OpenFilex.open(payload);
    }
  }

  static Future<void> showNotification(
    int id,
    String title,
    Map<String, dynamic> body,
    int seconds,
  ) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body['message'],
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main channel',
          channelDescription: 'Canal principal',
          priority: Priority.max,
          importance: Importance.max,
          icon: 'background',
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: body['filePath'],
    );
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
    }
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
