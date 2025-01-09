import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Blocs/blocobserver.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';
import 'package:lomi/src/app.dart';
import 'package:path_provider/path_provider.dart';

import 'src/Data/Repository/FirebaseMessaging/firebase_messaging.dart';
import 'src/Data/Repository/SharedPrefes/sharedPrefes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyB_jcF2LagMrT-HOLkMN5nKOHGN0lg_I0M', // Use API_KEY
        appId: '1:37534285903:ios:5f708fc1de194e155c2a3a', // Use GOOGLE_APP_ID
        messagingSenderId: '37534285903', // Use GCM_SENDER_ID
        projectId: 'habeshawe-1270a', // Use PROJECT_ID
        storageBucket:
            'habeshawe-1270a.appspot.com', // Adicione o Storage Bucket
      ),
    );
  } else {
    Firebase.initializeApp();
  }

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
