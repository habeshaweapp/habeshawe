// import 'dart:async';
// import 'dart:ui';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:lomi/src/Data/Models/enums.dart';
// import 'package:lomi/src/Data/Models/model.dart';
// import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
// import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';

// import '../SharedPrefes/sharedPrefes.dart';

// Future<void> initializeBackgroundService() async{
//   final service = FlutterBackgroundService();
  
//   //bool isRunn = await service.isRunning();

//   await service.configure(
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),

//     androidConfiguration: AndroidConfiguration(
//       autoStart: true,
//       onStart: onStart, 
//       isForegroundMode: true,
//       autoStartOnBoot: true
//       ));

  
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance serviceInstance)async{
//   // WidgetsFlutterBinding.ensureInitialized();
//   // DartPluginRegistrant.ensureInitialized();
//   onStart(serviceInstance);

//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async{
//   WidgetsFlutterBinding.ensureInitialized();
//   //DartPluginRegistrant.ensureInitialized();

//   await NotificationService().init();
//   await Firebase.initializeApp();
//   await SharedPrefes.init();

//   final _firebase = DatabaseRepository();

//   StreamSubscription? message;
//   StreamSubscription? likes;
//   StreamSubscription? matches;

//   service.on('stopService').listen((event) {
//     message?.cancel();
//     likes?.cancel();
//     matches?.cancel();
//     service.stopSelf();
   
//    // service.setAsBackgroundService();
//   });

//   service.on('user').listen((event) {
    
    

//     var Mfirst;
//     var Msecond;

//     matches= _firebase.getMatches(event?['userId'], Gender.values[ event?['gender']]).listen((event) {

      
//       if(Mfirst == null){
//         if(event.isNotEmpty){
//         Mfirst = event.first;
//         if(SharedPrefes.inBackground()==true){
//             NotificationService().showMessageReceivedNotifications(title: 'New Match', body: "You have a new Match!!", payload: 'chat', channelId: 'backgroundMatch');
//            }
//         }
//       }else{
//         Msecond = event.first;
//         if(!listEquals(Mfirst, Msecond)){
//            if(SharedPrefes.inBackground()==true){
//             NotificationService().showMessageReceivedNotifications(title: 'New Match', body: "You have a new Match!!", payload: 'chat', channelId: 'backgroundMatch');
//            }
//             Mfirst = Msecond;
            

//         }
//       }
//     });
//     var Lfirst;
//     var Lsecond;

//     likes =_firebase.getLikedMeUsers(event?['userId'], Gender.values[event?['gender']]).listen((event) {
//       if(Lfirst  == null){
//         if(event.isNotEmpty){
//           Lfirst = event.first;
//        if(SharedPrefes.inBackground()==true){
//           NotificationService().showMessageReceivedNotifications(title: 'New Like', body: 'Someone swiped right on you!!',payload: 'like', channelId: 'backgroundLike');
//        }
//         }
//       }else{
//         Lsecond = event.first;
//         if(!listEquals(Lfirst, Lsecond)){
//          if(SharedPrefes.inBackground()==true){
//           NotificationService().showMessageReceivedNotifications(title: 'New Like', body: 'Someone swiped right on you!!',payload: 'like', channelId: 'backgroundLike');
//          }
//          Lfirst = Lsecond;

//         }
//       }
     
//     });

//     UserMatch? Afirst;
//     UserMatch? Asecond;

//    message= _firebase.getactiveMatches(event?['userId'], Gender.values[event?['gender']]).listen((event) {
      
//       if(Afirst == null){
//         if(event.isNotEmpty){
//           Afirst = event.first;
//           if(SharedPrefes.inBackground()==true){
//             NotificationService().showMessageReceivedNotifications(title: 'Message', body: 'Someone Messaged you! ----------------- back', payload: 'chat', channelId: 'backgroundMessage');
//           }
//         }
//       }else{
//         Asecond = event.first;
//         if(Afirst!.timestamp != Asecond!.timestamp){
//           if(SharedPrefes.inBackground()==true){
//             NotificationService().showMessageReceivedNotifications(title: 'Message', body: 'Someone Messaged you! ----------------- back', payload: 'chat', channelId: 'backgroundMessage');
//           }
//           Afirst = Asecond;
            

//         }
//       }
     
//     });


//   });




//   service.on('activityStatus').listen((event) {
//     _firebase.updateOnlinestatus(userId: event?['userId'], gender: Gender.values[ event?['gender']], online: event?['online']);
//   });


//   // if(SharedPrefes.getUserId() != null){
//   //   Future.delayed(const Duration(seconds: 60),(){

//   //   service.invoke('users',{
//   //     'userId': SharedPrefes.getUserId(),
//   //     'gender': SharedPrefes.getGender(),
//   //     'isFirst': true
//   //   });

//   //   });
//   // }

  


// }