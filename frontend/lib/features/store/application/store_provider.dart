import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/store_api.dart';

final storeApiProvider = Provider<StoreApi>((ref) => StoreApi());

final storeProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final api = ref.watch(storeApiProvider);
  return await api.getStoreByUserId(userId);
});
