import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/product_api.dart';

final productApiProvider = Provider<ProductApi>((ref) => ProductApi());

final productListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(productApiProvider);
  return await api.getProducts();
});

final productListByUserProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
  final api = ref.watch(productApiProvider);
  return await api.getProductsByUser(userId);
});

final productByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, int>((ref, id) async {
  final api = ref.watch(productApiProvider);
  return await api.getProductById(id);
});

final createProductProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, product) async {
  final api = ref.watch(productApiProvider);
  final body = {
    ...product,
    "image_urls": (product["image_urls"] is List)
        ? product["image_urls"]
        : (product["image_urls"] != null ? [product["image_urls"]] : []),
  };
  return await api.createProduct(body);
});

final updateProductProvider =
    FutureProvider.family<Map<String, dynamic>?, Map<String, dynamic>>((ref, args) async {
  final api = ref.watch(productApiProvider);
  final id = args['id'] as int;
  final data = args['data'] as Map<String, dynamic>;
  final body = {
    ...data,
    "image_urls": (data["image_urls"] is List)
        ? data["image_urls"]
        : (data["image_urls"] != null ? [data["image_urls"]] : []),
  };
  return await api.updateProduct(id, body);
});

final deleteProductProvider = FutureProvider.family<bool, int>((ref, id) async {
  final api = ref.watch(productApiProvider);
  return await api.deleteProduct(id);
});
