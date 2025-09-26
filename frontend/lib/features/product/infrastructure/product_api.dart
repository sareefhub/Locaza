import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';

class ProductApi {
  Future<List<Map<String, dynamic>>> getProducts() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/products/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/products/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> product) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/products/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Map<String, dynamic>?> updateProduct(int id, Map<String, dynamic> product) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/products/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<bool> deleteProduct(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/products/$id");
    final response = await http.delete(url);

    return response.statusCode == 200;
  }
}
