import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/config/api_config.dart';
import 'package:frontend/utils/user_session.dart';

class UserApi {
  final String baseUrl = "${ApiConfig.baseUrl}/users";

  Future<List<Map<String, dynamic>>> getUsers() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (UserSession.token != null)
          "Authorization": "Bearer ${UserSession.token}",
      },
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    return [];
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (UserSession.token != null)
          "Authorization": "Bearer ${UserSession.token}",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> data) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateUser(int id, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<bool> deleteUser(int id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.delete(url);
    return response.statusCode == 200;
  }
}
