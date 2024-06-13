import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';

class FirebaseMessagingRepo{
  final _firebaseMessaging = FirebaseMessaging.instance;
  final localNotification = NotificationService();

  Future<void> initFirebaseMessaging()async{
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
   

    print(FCMToken);
    FirebaseMessaging.onMessage.listen((event) {
      final notif = event.notification;
      if(notif == null) return;

      localNotification.showMessageReceivedNotifications(title: notif.title!, body: notif.body!, payload: jsonEncode(event.toMap()), channelId: 'firebaseMsg');

     });
  }

  
}