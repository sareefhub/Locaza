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
}
