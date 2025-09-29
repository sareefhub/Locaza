import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/favorite_api.dart';
import 'package:frontend/utils/user_session.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Map<String, dynamic>>>((ref) {
  final notifier = FavoriteNotifier();
  final userId = int.tryParse(UserSession.id ?? '');
  if (userId != null) {
    notifier.loadFavoritesFromApi(userId);
  }
  return notifier;
});

class FavoriteNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final FavoriteApi _api = FavoriteApi();

  FavoriteNotifier() : super([]);

  // ------------------ ADD / REMOVE FAVORITE ------------------
  Future<void> addFavorite(Map<String, dynamic> product, int userId) async {
    final exists = state.any(
      (item) => item['product_id'] == product['id'] && item['user_id'] == userId,
    );

    if (!exists) {
      try {
        final newItem = await _api.addFavorite(userId, product['id']);
        if (newItem != null) {
          state = [...state, {...newItem, "product": product}];
          debugPrint(
            "✅ INSERT INTO wishlist_items (id, wishlist_id, product_id, created_at) "
            "VALUES (${newItem['id']}, ${newItem['wishlist_id']}, ${product['id']}, '${newItem['created_at']}');",
          );
        }
      } catch (e) {
        debugPrint("❌ addFavorite error: $e");
      }
    }
  }

  Future<void> removeFavorite(int productId, int userId) async {
    final removedItems = state.where((item) => item['product_id'] == productId).toList();

    if (removedItems.isNotEmpty) {
      final removed = removedItems.first;
      try {
        await _api.removeFavorite(removed['id']);
        state = state
            .where(
              (item) =>
                  !(item['product_id'] == productId &&
                      item['user_id'] == userId),
            )
            .toList();

        debugPrint(
          "🗑 DELETE FROM wishlist_items WHERE id=${removed['id']} AND product_id=$productId;",
        );
      } catch (e) {
        debugPrint("❌ removeFavorite error: $e");
      }
    }
  }

  bool isFavorite(int productId, int userId) {
    return state.any(
      (item) => item['product_id'] == productId && item['user_id'] == userId,
    );
  }

  // ------------------ LOAD FAVORITES FROM API ------------------
  Future<void> loadFavoritesFromApi(int userId) async {
    try {
      final data = await _api.getFavorites(userId);
      state = data;
      debugPrint("✅ Loaded favorites for user $userId (${state.length} items)");
    } catch (e) {
      debugPrint("❌ loadFavorites error: $e");
    }
  }

  // ------------------ GET FAVORITE PRODUCTS ------------------
  List<Map<String, dynamic>> get favoriteProducts =>
      state.map((item) => item['product'] as Map<String, dynamic>).toList();
}
