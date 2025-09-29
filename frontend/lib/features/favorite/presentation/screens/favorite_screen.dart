import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/favorite/application/favorite_provider.dart';
import 'package:frontend/core/widgets/product_card.dart';
import 'package:frontend/utils/user_session.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final userId = int.tryParse(UserSession.id ?? '');
    if (userId != null) {
      Future.microtask(() async {
        await ref.read(favoriteProvider.notifier).loadFavoritesFromApi(userId);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteProvider);
    final userId = int.tryParse(UserSession.id ?? '');
    final favorites = favoriteState
        .where((item) => item['user_id'] == userId && item['product'] != null)
        .map((item) => item['product'] as Map<String, dynamic>)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        centerTitle: true,
        title: Text(
          'รายการโปรด',
          style: GoogleFonts.sarabun(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/angle-small-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => context.go('/profile'),
        ),
      ),
      backgroundColor: Colors.white,
      body: DefaultTextStyle(
        style: GoogleFonts.sarabun(fontSize: 14, color: Colors.black),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : favorites.isEmpty
                ? const Center(child: Text('ยังไม่มีรายการโปรด'))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (_, index) {
                      final product = favorites[index];
                      return ProductCard(product: product);
                    },
                  ),
      ),
    );
  }
}
