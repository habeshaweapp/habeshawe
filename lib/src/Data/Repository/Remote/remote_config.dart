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

      await _remoteConfig.setDefaults(const{
        'interests': 'Jesus,LOve,Start ups,programming, 90s,Memes,Writing,Teddy Afro,Painting,torpa,kasech,Girma,astu,Aynalem,Library,Abrhot,6-kilo-meda,Law,Phd,3AM,Abyot,psychology,Photography,Walking,K-Pop,Reading,Sports,Instagram,Twitter,Facebook,Snapchat,HabeshaWe,Movies,Home Workout,Gym,Pull Up,Skateboarding,Stand Up Comedy,Coffee,Poetry,Singing,Painting,Dancing,Museum,Tea,Freelance,Hip Hop,Nightlife,Highland,Addis Street,Wello-Sefer,Meskel-Flower,Catcalling,Life',
        'shutDownBefore': '0.0.0',
        'UPDATELOCATIONAFTER':10,
        'showAd':true
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

  

  // static void checkShutUpdate(){
  //   shutDownStream.sink.addStream(getAppVersionToStop() )
  // }
  
}