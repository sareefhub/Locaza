import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String? id;
  static String? username;
  static String? name;
  static String? email;
  static String? phone;
  static String? avatarUrl;
  static String? location;
  static bool isVerified = false;
  static double reputationScore = 0.0;
  static String? createdAt;
  static String? updatedAt;
  static String? token;
  static bool isLoggedIn = false;

  static Future<void> clear() async {
    id = null;
    username = null;
    name = null;
    email = null;
    phone = null;
    avatarUrl = null;
    location = null;
    isVerified = false;
    reputationScore = 0.0;
    createdAt = null;
    updatedAt = null;
    token = null;
    isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (id != null) await prefs.setString('id', id!);
    if (username != null) await prefs.setString('username', username!);
    if (name != null) await prefs.setString('name', name!);
    if (email != null) await prefs.setString('email', email!);
    if (phone != null) await prefs.setString('phone', phone!);
    if (avatarUrl != null) await prefs.setString('avatar_url', avatarUrl!);
    if (location != null) await prefs.setString('location', location!);
    await prefs.setBool('is_verified', isVerified);
    await prefs.setDouble('reputation_score', reputationScore);
    if (createdAt != null) await prefs.setString('created_at', createdAt!);
    if (updatedAt != null) await prefs.setString('updated_at', updatedAt!);
    if (token != null) await prefs.setString('token', token!);
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    username = prefs.getString('username');
    name = prefs.getString('name');
    email = prefs.getString('email');
    phone = prefs.getString('phone');
    avatarUrl = prefs.getString('avatar_url');
    location = prefs.getString('location');
    isVerified = prefs.getBool('is_verified') ?? false;
    reputationScore = prefs.getDouble('reputation_score') ?? 0.0;
    createdAt = prefs.getString('created_at');
    updatedAt = prefs.getString('updated_at');
    token = prefs.getString('token');
    isLoggedIn = token != null && token!.isNotEmpty;
  }
}
