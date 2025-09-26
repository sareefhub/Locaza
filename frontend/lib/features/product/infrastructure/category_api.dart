import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/config/api_config.dart';

class CategoryApi {
  static const String endpoint = "${ApiConfig.baseUrl}/categories/";

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        final map = item as Map<String, dynamic>;
        map['image_url'] = ApiConfig.fixUrl(map['image_url']);
        return map;
      }).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
