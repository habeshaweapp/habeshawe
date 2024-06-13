import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefes{
  static late SharedPreferences _preferences;

  static const _keyMessages = 'messagesSeen';
  static const _keyLikes = 'likes';
  static const _keyTempLikes = 'templikes';
  static const _KeyMatches = 'matches';
  static const _keyTempMatches = 'tempMatches';

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

}