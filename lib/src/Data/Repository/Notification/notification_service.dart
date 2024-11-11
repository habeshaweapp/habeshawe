import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/ui/chat/chatscreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('noticon');

    // final DarwinInitializationSettings darwinInitializationSettings =
    //     DarwinInitializationSettings(
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      // iOS: darwinInitializationSettings,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    return null;
  }

  final DarwinNotificationDetails darwinNotificationDetails =
      const DarwinNotificationDetails();

  Future<void> showMessageReceivedNotifications(
      {required String title,
      required String body,
      required String payload,
      required String channelId}) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, 'Message $channelId',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'Message Notification');

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(100), title, body, notificationDetails,
        payload: payload);
  }

  Future<void> scheduleNotifications(
      {required String title,
      required String body,
      required String payload}) async {
    tz.initializeTimeZones();
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          27,
          title,
          body,
          tz.TZDateTime.now(tz.local).add(const Duration(hours: 24)),
          NotificationDetails(
              android: AndroidNotificationDetails(
            'dailymatches',
            'matches',
            importance: Importance.max,
            priority: Priority.high,
          )),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> cancelNotifications(int id) async {
    // await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    // await flutterLocalNotificationsPlugin.cancelAll();
  }
}
