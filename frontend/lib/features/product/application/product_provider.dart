import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/product_api.dart';

final productApiProvider = Provider<ProductApi>((ref) => ProductApi());

final productListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(productApiProvider);
  return await api.getProducts();
});

final productByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, int>((ref, id) async {
  final api = ref.watch(productApiProvider);
  return await api.getProductById(id);
});

final createProductProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, product) async {
  final api = ref.watch(productApiProvider);
  return await api.createProduct(product);
});

final updateProductProvider = FutureProvider.family<Map<String, dynamic>?, Map<String, dynamic>>((ref, args) async {
  final api = ref.watch(productApiProvider);
  final id = args['id'] as int;
  final data = args['data'] as Map<String, dynamic>;
  return await api.updateProduct(id, data);
});

final deleteProductProvider = FutureProvider.family<bool, int>((ref, id) async {
  final api = ref.watch(productApiProvider);
  return await api.deleteProduct(id);
});
