import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  Future<String?> uploadAvatar(File file) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/upload/avatar/");
    final request = http.MultipartRequest("POST", url);
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        file.path,
        contentType: MediaType("image", "jpeg"), // บังคับเป็น image/*
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["avatar_url"];
    } else {
      throw Exception("Upload avatar failed: ${response.statusCode} ${response.body}");
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String avatarUrl,
    required String location,
  }) async {
    if (UserSession.token == null) return null;

    final url = Uri.parse("${ApiConfig.baseUrl}/users/$userId");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${UserSession.token}",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "avatar_url": avatarUrl,
        "location": location,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Update profile failed: ${response.statusCode} ${response.body}");
    }
  }
}
