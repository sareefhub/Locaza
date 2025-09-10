class UserSession {
  static String? phone;
  static String? username;
  static String? userId;
  static String? profileImageUrl;

  static void clear() {
    phone = null;
    username = null;
    userId = null;
    profileImageUrl = null;
  }
}
