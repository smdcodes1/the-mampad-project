import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();

  static const String _usernameKey= 'username';
  static const String _nameKey= 'name';
  static const String _isLoggedIn= 'isLoggedIn';

  //isLoggedIn
  static Future<void> setLoggedIn(bool loggedvalue) async {
    final preferences= await SharedPreferences.getInstance();
    await preferences.setBool(_isLoggedIn, loggedvalue);
  }
  static Future<bool?> getLoggedIn() async {
    final preferences= await SharedPreferences.getInstance();
    return preferences.getBool(_isLoggedIn);
  }

  //username
  static Future<void> setUsername(String username) async {
    final preferences= await SharedPreferences.getInstance();
    await preferences.setString(_usernameKey, username);
  }
  static Future<String?> getUsername() async {
    final preferences= await SharedPreferences.getInstance();
    return preferences.getString(_usernameKey);
  }

  //name
  static Future<void> setname(String name) async {
    final preferences= await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, name);
  }
  static Future<String?> getname() async {
    final preferences= await SharedPreferences.getInstance();
    return preferences.getString(_nameKey);
  }

  static Future<void> clear() async {
    final preferences= await SharedPreferences.getInstance();
    await preferences.clear();
  }


}