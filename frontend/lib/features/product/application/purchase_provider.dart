import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/purchase_api.dart';

final purchaseApiProvider = Provider<PurchaseApi>((ref) => PurchaseApi());

final purchaseListProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, userId) async {
  final api = ref.watch(purchaseApiProvider);
  return api.getMyPurchases(userId);
});

final purchaseByIdProvider = FutureProvider.family<Map<String, dynamic>?, int>((ref, purchaseId) async {
  final api = ref.watch(purchaseApiProvider);
  return api.getPurchaseById(purchaseId);
});
