import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/favorite/application/favorite_provider.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/category_provider.dart';
import 'package:frontend/utils/user_session.dart';

class ProductCard extends ConsumerWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteProvider);
    final notifier = ref.read(favoriteProvider.notifier);
    final userId = int.tryParse(UserSession.id ?? '');

    final isFavorite = userId != null
        ? favoriteState.any(
            (item) =>
                item['product_id'] == product['id'] &&
                item['user_id'] == userId,
          )
        : false;

    final categories = ref
        .watch(categoryListProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);

    final categoryName = categories
        .firstWhere(
          (c) => c['id'] == product['category_id'],
          orElse: () => {'name': ''},
        )['name']
        .toString();

    // ✅ เลือกรูปภาพแรกเสมอ
    String image = '';
    final rawImage = product['image_urls'];
    if (rawImage is List && rawImage.isNotEmpty) {
      image = rawImage.first.toString();
    } else if (rawImage is String && rawImage.isNotEmpty) {
      image = rawImage;
    }

    const favoriteIconSize = 22.0;

    Widget buildImage(double imageHeight) {
      if (image.isEmpty) {
        return SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: Image.asset(
            'assets/products-image/placeholder_product.png',
            fit: BoxFit.cover,
          ),
        );
      }
      return SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Image.network(
          ApiConfig.fixUrl(image),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Image.asset('assets/products-image/placeholder_product.png', fit: BoxFit.cover),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final imageHeight = cardWidth * 0.8;

        return InkWell(
          onTap: () {
            GoRouter.of(context).push('/product_details/${product['id']}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: buildImage(imageHeight),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: favoriteIconSize + 8,
                          height: favoriteIconSize + 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: favoriteIconSize,
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              if (userId == null) return;

                              if (isFavorite) {
                                notifier.removeFavorite(product['id'], userId);
                              } else {
                                notifier.addFavorite(product, userId);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product['title']?.toString() ?? '',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  categoryName,
                  style: GoogleFonts.sarabun(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product['location']?.toString() ?? '',
                  style: GoogleFonts.sarabun(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '฿${product['price'] ?? ''}',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF315EB2),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
