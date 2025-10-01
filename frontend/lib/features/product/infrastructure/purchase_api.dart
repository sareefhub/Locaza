import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';

class PurchaseApi {
  Future<List<Map<String, dynamic>>> getMyPurchases(int userId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/$userId/transactions/purchases");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load purchases");
    }
  }

  Future<Map<String, dynamic>?> getPurchaseById(int purchaseId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/sale_transactions/$purchaseId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPurchaseByProduct(int productId, int buyerId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/$buyerId/transactions/purchases");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      try {
        return data.firstWhere((p) => p['product_id'] == productId, orElse: () => null);
      } catch (e) {
        return null;
      }
    } else {
      throw Exception("Failed to fetch purchase by product");
    }
  }

  Future<Map<String, dynamic>> createPurchase(Map<String, dynamic> data) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/sale_transactions/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (!json.containsKey('id')) {
        throw Exception("API response missing transaction id");
      }
      return json;
    } else {
      throw Exception("Failed to create purchase: ${response.body}");
    }
  }
}
