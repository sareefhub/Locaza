import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProductCard extends ConsumerWidget {
  final Map<String, dynamic> product;

  const MyProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ดึงชื่อ category
    final categories = ref
        .watch(categoryListProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);

    final categoryName = categories
        .firstWhere(
          (c) => c['id'] == product['category_id'],
          orElse: () => {'name': ''},
        )['name']
        .toString();

    // เลือกรูปภาพแรก
    String image = '';
    final rawImage = product['image_urls'];
    if (rawImage is List && rawImage.isNotEmpty) {
      image = rawImage.first.toString();
    } else if (rawImage is String && rawImage.isNotEmpty) {
      image = rawImage;
    }

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
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/products-image/placeholder_product.png',
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
            GoRouter.of(context).push('/my_product_details/${product['id']}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: buildImage(imageHeight),
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
