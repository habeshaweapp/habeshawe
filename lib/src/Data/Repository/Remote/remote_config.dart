import 'dart:convert';

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
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero
        )
      );

      await _remoteConfig.setDefaults({
        'interests': 'Jesus,LOve,Start ups,programming, 90s,Memes,Writing,Teddy Afro,Painting,torpa,kasech,Girma,astu,Aynalem,Library,Abrhot,6-kilo-meda,Law,Phd,3AM,Abyot,psychology,Photography,Walking,K-Pop,Reading,Sports,Instagram,Twitter,Facebook,Snapchat,HabeshaWe,Movies,Home Workout,Gym,Pull Up,Skateboarding,Stand Up Comedy,Coffee,Poetry,Singing,Painting,Dancing,Museum,Tea,Freelance,Hip Hop,Nightlife,Highland,Addis Street,Wello-Sefer,Meskel-Flower,Life',
        'shutDownBefore': '0.0.0',
        'UPDATELOCATIONAFTER':10,
        'showAd':true,
        'boostTime':30,
        'sampleTexts': 'Temari nesh serategna?, Hi kongo, Hey, Hi',
        'numbers' : jsonEncode({
          'queensNumber':2,
          'gentsNumber':3,
          'howManyADayWomen':10,
          'howManyADayMen':10,
          'maxKmNearBy':2,
          'numberOfDiascora':10,
          'adsForQueen': 10,
          'adsForPrincess': 5,
          'settingsKmNearBy':10,
          'useMainLogic':false,
          'maxAge':60
        }),
        'ETusersPay':false,
        'showDeleteAccount':false,
        'ai': jsonEncode({
          'screenshot': true,
          'poster': true,
          'screenshotConfidence': 0.5,
          'posterConfidence':0.5,
          'face':true,
          'removeBoost':false
        }),
        'showAdREORN': false,
        'ETbuyQP': false,
        'ETWomensPay': true
        
      });

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

  int getCount(String key) => _remoteConfig.getInt(key);

  String getInterests() => _remoteConfig.getString('interests');

  int updatLocationAfter() => _remoteConfig.getInt('UPDATELOCATIONAFTER');

  bool showAd() => _remoteConfig.getBool('showAd');

  int boostTime() => _remoteConfig.getInt('boostTime');

  String sampleTexts() => _remoteConfig.getString('sampleTexts');

  bool ETusersPay() => _remoteConfig.getBool('ETusersPay');

  bool showDeleteAccount() => _remoteConfig.getBool('showDeleteAccount');

  // int queenNumber() => _remoteConfig.getInt('queensNumber');

  // int gentNumber() => _remoteConfig.getInt('gentsNumber');

  // int howManyADayWomen() => _remoteConfig.getInt('howManyADayWomen');

  // int howManyADayMen() => _remoteConfig.getInt('howManyADayMen');

  // int maxKmNearBy() => _remoteConfig.getInt('maxKmNearBy');
  
  Map<String, dynamic> getNumbers() => jsonDecode(_remoteConfig.getString('numbers')) as Map<String,dynamic>;

  Map<String, dynamic> ai() => jsonDecode(_remoteConfig.getString('ai')) as Map<String,dynamic>;
  
  bool showAdREORN() => _remoteConfig.getBool('showAdREORN');

  bool ETbuyQP() => _remoteConfig.getBool('ETbuyQP');

  bool ETWomensPay() => _remoteConfig.getBool('ETWomensPay');


  

  // static void checkShutUpdate(){
  //   shutDownStream.sink.addStream(getAppVersionToStop() )
  // }
  
}