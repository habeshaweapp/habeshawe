import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:rxdart/rxdart.dart';

class RemoteConfigService{
  static final RemoteConfigService _remoteConfigService =  RemoteConfigService._internal();
  factory RemoteConfigService(){
    return _remoteConfigService;
  }

  RemoteConfigService._internal();



  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static final shutDownStream = BehaviorSubject<String>();

   Future<void> init()async{
    try{
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 20),
          minimumFetchInterval: Duration.zero
        )
      );

      await _remoteConfig.fetchAndActivate();

      _remoteConfig.onConfigUpdated.listen((event)async {
        await _remoteConfig.activate();
        print(event.updatedKeys);
        shutDownStream.add(event.updatedKeys.first);
        
      });

    } on FirebaseException catch(e,st){
      print('unable to initialize firebase Remote config');
    }
  }

  //_remoteConfig.onConfigUpdated

  String getAppVersionToStop() => _remoteConfig.getString('shutDownBefore');

  bool shutDownBefore() => _remoteConfig.getBool('shutDownBefore');

  // static void checkShutUpdate(){
  //   shutDownStream.sink.addStream(getAppVersionToStop() )
  // }
  
}