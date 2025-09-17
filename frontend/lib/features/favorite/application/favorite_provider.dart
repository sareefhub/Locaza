// providers/favorite_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider เก็บรายการสินค้าที่ถูก favorite
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Map<String, dynamic>>>(
      (ref) => FavoriteNotifier(),
    );

class FavoriteNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoriteNotifier() : super([]);

  void addFavorite(Map<String, dynamic> product) {
    // ป้องกันการกดซ้ำ
    if (!state.any((p) => p['id'] == product['id'])) {
      state = [...state, product];
    }
  }

  void removeFavorite(int productId) {
    state = state.where((p) => p['id'] != productId).toList();
  }

  bool isFavorite(int productId) {
    return state.any((p) => p['id'] == productId);
  }
}
