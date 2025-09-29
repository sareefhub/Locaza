import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/api_config.dart';
import '../../../../utils/user_session.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) => NotificationApi());

class NotificationApi {
  final baseUrl = "${ApiConfig.baseUrl}/notifications";

  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    final userId = UserSession.id;
    final url = Uri.parse("$baseUrl/user/$userId");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  Future<void> markAsRead(int id) async {
    final url = Uri.parse("$baseUrl/$id/read");
    var res = await http.patch(url);
    if (res.statusCode == 405) {
      res = await http.put(url);
    }
    if (res.statusCode != 200) {
      throw Exception("Failed to mark notification as read");
    }
  }
}
