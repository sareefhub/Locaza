import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';
import '../../../../utils/user_session.dart';

class ProfileApi {
  Future<Map<String, dynamic>?> getProfile() async {
    if (UserSession.token == null) return null;

    final url = Uri.parse("${ApiConfig.baseUrl}/auth/me");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${UserSession.token}",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Fetch profile failed: ${response.statusCode} ${response.body}");
    }
  }
}
