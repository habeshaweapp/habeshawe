import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Blocs/blocobserver.dart';
import 'package:lomi/src/Data/Repository/BackgroundService/flutter_background_service.dart';
import 'package:lomi/src/Data/Repository/FirebaseMessaging/firebase_messaging.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';
import 'package:lomi/src/app.dart';
import 'package:path_provider/path_provider.dart';

import 'src/Data/Repository/SharedPrefes/sharedPrefes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await Firebase.initializeApp();
  
  Bloc.observer = MyBlocObserver(); 
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationCacheDirectory());  
  MobileAds.instance.initialize();
  await NotificationService().init();
  await RemoteConfigService().init();
  await SharedPrefes.init();
  await FirebaseMessagingRepo().initFirebaseMessaging();
 // await initializeBackgroundService();
  runApp(const MyApp());
  
} 

 
 