import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';

class ReviewApi {
  Future<Map<String, dynamic>> createReview(Map<String, dynamic> data) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/reviews/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create review: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> getReviewsBySeller(int sellerId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/reviews/?seller_id=$sellerId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load reviews");
    }
  }
}
