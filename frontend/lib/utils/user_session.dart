import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String? id;
  static String? username;
  static String? phone;
  static String? avatarUrl;
  static String? token;
  static bool isLoggedIn = false;

  static Future<void> clear() async {
    id = null;
    username = null;
    phone = null;
    avatarUrl = null;
    token = null;
    isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (id != null) await prefs.setString('id', id!);
    if (username != null) await prefs.setString('username', username!);
    if (phone != null) await prefs.setString('phone', phone!);
    if (avatarUrl != null) await prefs.setString('avatarUrl', avatarUrl!);
    if (token != null) await prefs.setString('token', token!);
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    username = prefs.getString('username');
    phone = prefs.getString('phone');
    avatarUrl = prefs.getString('avatarUrl');
    token = prefs.getString('token');
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }
}
