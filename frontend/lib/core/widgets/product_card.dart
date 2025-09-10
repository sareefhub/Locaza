import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product['image']?.toString() ?? '';
    const cardWidth = 160.0;
    const imageHeight = 140.0;

    int rating = 0;
    final ratingRaw = product['rating'];
    if (ratingRaw is int) {
      rating = ratingRaw;
    } else if (ratingRaw is double) {
      rating = ratingRaw.floor();
    }

    Widget buildImage() {
      if (image.isEmpty) {
        return Image.asset(
          'assets/images/placeholder.png',
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
      if (image.startsWith('http')) {
        return Image.network(
          image,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/placeholder.png',
            height: imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      }
      return Image.asset(
        image,
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: buildImage(),
          ),
          const SizedBox(height: 6),
          Text(
            product['category']?.toString() ?? '',
            style: GoogleFonts.sarabun(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            product['name']?.toString() ?? '',
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
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
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < rating ? Icons.star : Icons.star_border,
                size: 14,
                color: Colors.orange,
              );
            }),
          ),
          const Spacer(),
          Text(
            '${product['price'] ?? ''} บาท',
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
