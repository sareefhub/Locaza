import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/features/product/application/product_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:frontend/features/product/presentation/screens/widgets/fullscreen_image_viewer.dart';

class MyProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;

  const MyProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<MyProductDetailsPage> createState() =>
      _MyProductDetailsPageState();
}

class _MyProductDetailsPageState extends ConsumerState<MyProductDetailsPage> {
  bool showFullDescription = false;
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

            // ✅ แปลง image_urls เป็น List<String>
            List<String> images = [];
            final rawImage = product['image_urls'];
            if (rawImage is List) {
              images = rawImage
                  .map((e) => ApiConfig.fixUrl(e.toString()))
                  .toList();
            } else if (rawImage is String && rawImage.isNotEmpty) {
              images = [ApiConfig.fixUrl(rawImage)];
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
                  // ✅ ส่วนแสดงรูปภาพ
                  Stack(
                    children: [
                      SizedBox(
                        height: 310,
                        width: double.infinity,
                        child: images.isNotEmpty
                            ? PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final img = images[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullscreenImageViewer(
                                            images: images,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: img,
                                      child: Image.network(
                                        img,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/products-image/placeholder_product.png',
                                fit: BoxFit.cover,
                              ),
                      ),

                      // ปุ่ม Back
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

                      // ✅ Indicator
                      if (images.length > 1)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              SmoothPageIndicator(
                                controller: _pageController,
                                count: images.length,
                                effect: const ExpandingDotsEffect(
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.white54,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                ),
                                onDotClicked: (index) {
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_currentIndex + 1}/${images.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  // ✅ ส่วนรายละเอียดสินค้า
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
