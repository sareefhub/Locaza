import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/category_api.dart';

final categoryApiProvider = Provider<CategoryApi>((ref) => CategoryApi());

final categoryListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(categoryApiProvider);
  return await api.getCategories();
});
