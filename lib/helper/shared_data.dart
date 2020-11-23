import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  // SAVE USER DATA
  static saveUserPreferences(value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("USER", json.encode(value));
  }

  // READ USER DATA
  static readUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString("USER"));
  }

  // SESSION DATA
  static isUserLoggedIn(value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('LOGIN', value);
  }

  static readUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('LOGIN') != null) {
      return prefs.getBool('LOGIN');
    } else {
      return false;
    }
  }

  // REMOVE ALL PREFERENCES
  static removeAllPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
