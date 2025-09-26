import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/favorite/application/favorite_provider.dart';
import 'package:frontend/config/api_config.dart';

class ProductCard extends ConsumerWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteProvider);
    final isFavorite = favoriteState.any(
      (item) => item['product_id'] == product['id'],
    );
    final notifier = ref.read(favoriteProvider.notifier);

    final image = product['image_urls']?.toString() ?? '';
    const favoriteIconSize = 22.0;

    Widget buildImage(double imageHeight) {
      if (image.isEmpty) {
        return SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: Image.asset(
            'assets/images/placeholder.png',
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
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/placeholder.png',
            fit: BoxFit.cover,
          ),
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
                              final userId = 101;
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
