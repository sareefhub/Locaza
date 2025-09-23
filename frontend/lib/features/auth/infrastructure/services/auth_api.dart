import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';

class AuthApi {
  final String baseUrl = "${ApiConfig.baseUrl}/auth";

  Future<String> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> register(
      String username, String password, String email, String phone) async {
    final url = Uri.parse('$baseUrl/register/username');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "email": email,
        "phone": phone,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Register failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> me(String token) async {
    final url = Uri.parse('$baseUrl/me');
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fetch user failed: ${response.body}');
    }
  }
}
