import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefes{
  static late SharedPreferences _preferences;

  static const _keyMessages = 'messagesSeen';

  static Future init() async => 
    _preferences = await SharedPreferences.getInstance();

  static Future setMessagesNotified(List<String> msgIds) async =>
    await _preferences.setStringList(_keyMessages, msgIds);

  static List<String>? getMessagesNotified() => _preferences.getStringList(_keyMessages);

}