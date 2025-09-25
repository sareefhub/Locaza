import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/navigation.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/category_list.dart';
import 'package:frontend/data/dummy_products.dart';
import 'package:frontend/data/dummy_categories.dart';
import 'package:frontend/data/dummy_users.dart';
import 'package:frontend/routing/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  int _getCrossAxisCount(double width) {
    if (width >= 1600) return 6; // Desktop ใหญ่
    if (width >= 1300) return 5;
    if (width >= 1000) return 4;
    if (width >= 600) return 3; // Tablet
    return 2; // Mobile
  }

  double _getChildAspectRatio(double screenWidth, int crossAxisCount) {
    // คำนวณความกว้างของ card
    double padding = 16 * 2; // padding ของ SliverPadding
    double spacing = 12 * (crossAxisCount - 1); // spacing ระหว่าง card
    double cardWidth = (screenWidth - padding - spacing) / crossAxisCount;

    // height ของ card ประกอบด้วย
    // - รูปภาพ (80% ของความกว้าง)
    // - ข้อความ + ปุ่ม ประมาณ 120
    double cardHeight = cardWidth * 0.8 + 120;

    return cardWidth / cardHeight;
  }

  // ฟิลเตอร์สินค้า: แสดงเฉพาะสินค้าที่ยังว่างและผู้ขายถูกต้อง
  List<Map<String, dynamic>> _getBestSaleProducts() {
    return dummyProducts
        .where((product) {
          final seller = dummyUsers.firstWhere(
            (u) => u['id'] == product['seller_id'],
            orElse: () => {},
          );
          return product['status'] == 'available' && seller.isNotEmpty;
        })
        .take(8)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, sizingInfo) {
            final screenWidth = sizingInfo.screenSize.width;
            final crossAxisCount = _getCrossAxisCount(screenWidth);
            final bestSaleProducts = _getBestSaleProducts();

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/logo.png', height: 24),
                        const SizedBox(width: 6),
                        if (!sizingInfo.isMobile)
                          Expanded(
                            child: Text(
                              'Local Community Marketplace',
                              style: GoogleFonts.notoSansThai(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () => context.push(AppRoutes.search),
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'ค้นหา',
                              style: GoogleFonts.sarabun(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Categories
                SliverToBoxAdapter(
                  child: CategoryList(categories: dummyCategories),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Products Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ProductCard(product: bestSaleProducts[index]),
                      childCount: bestSaleProducts.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: _getChildAspectRatio(
                        screenWidth,
                        crossAxisCount,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
