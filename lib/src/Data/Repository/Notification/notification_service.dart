import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/ui/chat/chatscreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  Future<void> init() async{
   const AndroidInitializationSettings androidInitializationSettings =
     AndroidInitializationSettings('ic_launcher');

   final DarwinInitializationSettings darwinInitializationSettings =
     DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
     );

  final InitializationSettings initializationSettings = 
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      
      );

  }

  void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload )async{
      // showDialog(
      //   context: BuildContext context, 
      //   builder: (BuildContext context) => CupertinoAlertDialog(
      //     title: Text(title?? ''),
      //     content: Text(body??''),
      //     actions: [
      //       CupertinoDialogAction(
      //         isDefaultAction: true,
      //         child: Text('Ok'),
      //         onPressed: ()async{
      //           Navigator.of(context,rootNavigator: true).pop();
      //           await Navigator.push(context, MaterialPageRoute(
      //             builder: (context) => ChatScreen(payload as UserMatch)
      //             ));
      //         }
      //         )
      //     ],
      //   ) );

  }
  
   static AndroidNotificationDetails _androidNotificationDetails = 
    const AndroidNotificationDetails(
      'id1', 
      'Message',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'msgNoti'
      );

   static final DarwinNotificationDetails darwinNotificationDetails = 
      const DarwinNotificationDetails();

   NotificationDetails notificationDetails =
          NotificationDetails(
            android: _androidNotificationDetails,
            iOS: darwinNotificationDetails
          ); 

      Future<void> showNotifications()async{
        

        await flutterLocalNotificationsPlugin.show(
          0, 
          "title", 
          'body', 
          notificationDetails,
          payload: 'nOTIFcation payload'
          );
      }

  Future<void> scheduleNotifications() async{
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, 
      'title', 
      'body', 
      tz.TZDateTime.now(tz.local).add(const Duration(minutes: 5)) , 
      notificationDetails, 
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
      );
  }

  Future<void> cancelNotifications(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
      
  
}