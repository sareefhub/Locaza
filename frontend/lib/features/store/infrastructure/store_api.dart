import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';

class StoreApi {
  Future<Map<String, dynamic>> getStoreByUserId(String userId) async {
    final userUrl = Uri.parse("${ApiConfig.baseUrl}/users/$userId");
    final userRes = await http.get(userUrl);
    if (userRes.statusCode != 200) throw Exception("Failed to load user");
    final user = jsonDecode(userRes.body);

    final productUrl = Uri.parse("${ApiConfig.baseUrl}/users/$userId/products");
    final productRes = await http.get(productUrl);
    final products = productRes.statusCode == 200
        ? List<Map<String, dynamic>>.from(jsonDecode(productRes.body))
        : [];

    final reviewUrl =
        Uri.parse("${ApiConfig.baseUrl}/reviews/?seller_id=$userId");
    final reviewRes = await http.get(reviewUrl);
    final reviews = reviewRes.statusCode == 200
        ? List<Map<String, dynamic>>.from(jsonDecode(reviewRes.body))
        : [];

    final categoryUrl = Uri.parse("${ApiConfig.baseUrl}/categories/");
    final categoryRes = await http.get(categoryUrl);
    final categories = categoryRes.statusCode == 200
        ? List<String>.from(jsonDecode(categoryRes.body).map((c) => c['name']))
        : [];

    return {
      "id": user["id"].toString(),
      "name": user["username"] ?? "ร้านค้า",
      "avatar_url": user["avatar_url"] ?? "",
      "rating": user["rating"] ?? 0,
      "followers": user["followers"] ?? 0,
      "products": products,
      "reviews": reviews,
      "categories": categories,
    };
  }
}
