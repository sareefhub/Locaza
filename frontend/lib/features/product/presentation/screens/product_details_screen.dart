import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/product_card.dart';
import 'package:frontend/data/dummy_products.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  late Map<String, dynamic> product;
  bool showFullDescription = false;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final String productDescription =
        (product['description'] != null &&
            product['description'].toString().isNotEmpty)
        ? product['description'].toString()
        : 'ไม่มีรายละเอียดสินค้า';

    final bool hasLongDescription =
        productDescription.split('\n').length > 2 ||
        productDescription.length > 100;

    final similarProducts = dummyProducts
        .where(
          (p) =>
              p['category'] == product['category'] &&
              p['name'] != product['name'],
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      product['image'] ?? 'assets/images/placeholder.png',
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
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        icon: Icon(
                          false ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          // TODO: เพิ่มฟังก์ชัน favorite
                        },
                      ),
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
                      product['price'] ?? '',
                      style: GoogleFonts.sarabun(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF315EB2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['name'] ?? '',
                      style: GoogleFonts.sarabun(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9E1E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.category, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'หมวดหมู่',
                            style: GoogleFonts.sarabun(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product['category'] ?? '',
                            style: GoogleFonts.sarabun(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Location
                    if (product['location'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9E1E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ตำแหน่ง',
                              style: GoogleFonts.sarabun(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product['location'],
                              style: GoogleFonts.sarabun(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Divider
                    Divider(color: Colors.grey.shade400, thickness: 1),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(
                              product['sellerImage'] ?? '',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['sellerName'] ?? 'ไม่ทราบชื่อผู้ขาย',
                                  style: GoogleFonts.sarabun(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      GoRouter.of(context).push('/login');
                                    },
                                    icon: const Icon(
                                      Icons.chat,
                                      color: Color(0xFF315EB2),
                                    ),
                                    label: Text(
                                      "แชต",
                                      style: GoogleFonts.sarabun(
                                        color: const Color(0xFF315EB2),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFF315EB2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (similarProducts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สินค้าที่คล้ายกัน',
                            style: GoogleFonts.sarabun(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 280,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: similarProducts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final sp = similarProducts[index];
                                return ProductCard(product: sp);
                              },
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
