import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefes{
  static late SharedPreferences _preferences;

  static const _keyMessages = 'messagesSeen';
  static const _keyLikes = 'likes';
  static const _keyTempLikes = 'templikes';
  static const _KeyMatches = 'matches';
  static const _keyTempMatches = 'tempMatches';
  static const _KeyfirstLogIn = 'firstLogIn';
  static const _keyInBackground = 'inBackground';

  static Future init() async => 
    _preferences = await SharedPreferences.getInstance();

  static Future setMessagesNotified(List<String> msgIds) async =>
    await _preferences.setStringList(_keyMessages, msgIds);

  static List<String>? getMessagesNotified() => _preferences.getStringList(_keyMessages);

  static int? getLikesCounts()=> _preferences.getInt(_keyLikes);

  static Future setLikesCount(int count)async => await _preferences.setInt(_keyLikes, count);

  static int? getTempLikesCounts()=> _preferences.getInt(_keyTempLikes);

  static Future setTempLikesCount(int count)async => await _preferences.setInt(_keyTempLikes, count);

  static final newLike = BehaviorSubject<String>();
  static final newMessage = BehaviorSubject<String>();

  static Future setAppState(bool state) async => await _preferences.setBool('appState', state);
  static bool? getAppStateOnBg() => _preferences.getBool('state');

  //for new matches
  static final newMatch = BehaviorSubject<String>();
  static int? getMatchesCount()=> _preferences.getInt(_KeyMatches);
  static Future setMatchesCount(int count) async => await _preferences.setInt(_KeyMatches, count);
  
  static int? getTempMatchesCounts()=> _preferences.getInt(_keyTempMatches);

  static Future setTempMatchesCount(int count)async => await _preferences.setInt(_keyTempMatches, count);

  static bool? getFirstLogIn()=> _preferences.getBool(_KeyfirstLogIn);

  static Future setFirstLogIn(bool isFirst)async=> await _preferences.setBool(_KeyfirstLogIn, isFirst);

  static Future setInBackground(bool back)async => await _preferences.setBool(_keyInBackground, back);

  static bool? inBackground() => _preferences.getBool(_keyInBackground);


  static Future setUserId(String userId)async => await _preferences.setString('userId', userId);
  static String? getUserId()=>_preferences.getString('userId');

  static Future setGender(int gender)async => await _preferences.setInt('gender', gender);
  static int? getGender()=>_preferences.getInt('gender');



  static void clear(){
    _preferences.clear();
  }

}