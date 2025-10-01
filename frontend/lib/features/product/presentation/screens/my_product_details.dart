import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/product_provider.dart';

class MyProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;

  const MyProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<MyProductDetailsPage> createState() =>
      _MyProductDetailsPageState();
}

class _MyProductDetailsPageState extends ConsumerState<MyProductDetailsPage> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: productState.when(
          data: (product) {
            if (product == null) {
              return const Center(child: Text("ไม่พบสินค้า"));
            }

            // จัดการรูป
            final rawImage = product['image_urls'];
            String image = '';
            if (rawImage is List && rawImage.isNotEmpty) {
              image = rawImage.first.toString();
            } else if (rawImage is String && rawImage.isNotEmpty) {
              image = rawImage;
            }

            final productDescription =
                (product['description'] != null &&
                    product['description'].toString().isNotEmpty)
                ? product['description'].toString()
                : 'ไม่มีรายละเอียดสินค้า';

            final hasLongDescription =
                productDescription.split('\n').length > 2 ||
                productDescription.length > 100;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        child: image.isNotEmpty
                            ? Image.network(
                                ApiConfig.fixUrl(image),
                                height: 310,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/products-image/placeholder_product.png',
                                height: 310,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 16,
                        left: 8,
                        child: IconButton(
                          icon: Image.asset(
                            'assets/icons/angle-small-left.png',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '฿${product['price'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF315EB2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['title'] ?? '',
                          style: GoogleFonts.sarabun(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.grey, thickness: 1),
                        const SizedBox(height: 8),
                        Text(
                          'รายละเอียดสินค้า',
                          style: GoogleFonts.sarabun(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          productDescription,
                          maxLines: showFullDescription ? null : 2,
                          overflow: showFullDescription
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: GoogleFonts.sarabun(fontSize: 14),
                        ),
                        if (hasLongDescription)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showFullDescription = !showFullDescription;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  showFullDescription
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: const Color(0xFF315EB2),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  showFullDescription
                                      ? "ดูน้อยลง"
                                      : "อ่านเพิ่มเติม",
                                  style: GoogleFonts.sarabun(
                                    fontSize: 14,
                                    color: const Color(0xFF315EB2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
