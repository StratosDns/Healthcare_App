import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _usersKey = 'users'; // JSON map of users
  static const String _currentUserKey = 'currentUser';
  static const String _isLoggedInKey = 'isLoggedIn';

  static Future<void> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> users = {};

    final usersString = prefs.getString(_usersKey);
    if (usersString != null && usersString.isNotEmpty) {
      users = json.decode(usersString);
    }

    users[username] = password;
    await prefs.setString(_usersKey, json.encode(users));
  }

  static Future<bool> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_usersKey);
    if (usersString == null) return false;
    final users = json.decode(usersString);
    if (users[username] == password) {
      await prefs.setString(_currentUserKey, username);
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }
    return false;
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_currentUserKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}