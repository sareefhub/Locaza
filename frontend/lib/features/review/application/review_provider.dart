import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/review_api.dart';

final reviewApiProvider = Provider<ReviewApi>((ref) => ReviewApi());

final createReviewProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, data) async {
  final api = ref.watch(reviewApiProvider);
  return api.createReview(data);
});

final reviewsBySellerProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, sellerId) async {
  final api = ref.watch(reviewApiProvider);
  return api.getReviewsBySeller(sellerId);
});
