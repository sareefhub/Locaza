// favorite_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // debugPrint
import 'package:frontend/data/dummy_favorites.dart';
import 'package:frontend/data/dummy_products.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Map<String, dynamic>>>(
      (ref) => FavoriteNotifier(),
    );

class FavoriteNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoriteNotifier() : super([]) {
    loadFavoritesFromPrefs(); // โหลด favorite ตอนเริ่ม
  }

  // ------------------ ADD / REMOVE FAVORITE ------------------
  Future<void> addFavorite(Map<String, dynamic> product, int userId) async {
    final wishlistId = mockWishlists.first['id'];

    final exists = state.any((item) => item['product_id'] == product['id']);
    if (!exists) {
      final newItem = {
        'id': state.length + 1,
        'wishlist_id': wishlistId,
        'product_id': product['id'],
        'created_at': DateTime.now().toIso8601String(),
        'product': product,
      };
      state = [...state, newItem];

      debugPrint(
        "✅ INSERT INTO wishlist_items "
        "(id, wishlist_id, product_id, created_at) "
        "VALUES (${newItem['id']}, $wishlistId, ${product['id']}, '${newItem['created_at']}');",
      );

      await _saveFavoritesToPrefs(userId);
    }
  }

  Future<void> removeFavorite(int productId, {int userId = 101}) async {
    final removedItems = state
        .where((item) => item['product_id'] == productId)
        .toList();

    state = state.where((item) => item['product_id'] != productId).toList();

    if (removedItems.isNotEmpty) {
      final removed = removedItems.first;
      debugPrint(
        "🗑 DELETE FROM wishlist_items WHERE id=${removed['id']} AND product_id=$productId;",
      );
      await _saveFavoritesToPrefs(userId);
    }
  }

  bool isFavorite(int productId) {
    return state.any((item) => item['product_id'] == productId);
  }

  // ------------------ LOCAL STORAGE ------------------
  Future<void> _saveFavoritesToPrefs(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final productIds = state
        .map((item) => item['product_id'].toString())
        .toList();
    await prefs.setStringList('favorite_$userId', productIds);
  }

  Future<void> loadFavoritesFromPrefs({int userId = 101}) async {
    final prefs = await SharedPreferences.getInstance();
    final productIds = prefs.getStringList('favorite_$userId') ?? [];

    // โหลด product map จาก mockProducts
    state = dummyProducts
        .where((p) => productIds.contains(p['id'].toString()))
        .map(
          (p) => {
            'id': state.length + 1,
            'wishlist_id': mockWishlists.first['id'],
            'product_id': p['id'],
            'created_at': DateTime.now().toIso8601String(),
            'product': p,
          },
        )
        .toList();
  }

  // ------------------ GET FAVORITE PRODUCTS ------------------
  List<Map<String, dynamic>> get favoriteProducts =>
      state.map((item) => item['product'] as Map<String, dynamic>).toList();
}
