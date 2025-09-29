import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';

class FavoriteApi {
  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/favorites/users/$userId/favorites");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) {
        final item = e as Map<String, dynamic>;
        if (item['product'] != null && item['product']['image_urls'] is String) {
          item['product']['image_urls'] = [item['product']['image_urls']];
        }
        return item;
      }).toList();
    } else {
      throw Exception("Failed to load favorites");
    }
  }

  Future<Map<String, dynamic>?> addFavorite(int userId, int productId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/favorites/");
    final body = jsonEncode({
      "user_id": userId,
      "product_id": productId,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['product'] != null && data['product']['image_urls'] is String) {
        data['product']['image_urls'] = [data['product']['image_urls']];
      }
      return data;
    } else {
      throw Exception("Failed to add favorite");
    }
  }

  Future<void> removeFavorite(int favoriteId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/favorites/$favoriteId");
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to remove favorite");
    }
  }
}
