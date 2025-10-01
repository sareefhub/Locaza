import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/navigation.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/category_list.dart';
import 'package:frontend/routing/routes.dart';
import '../../../product/application/product_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  int _getCrossAxisCount(double width) {
    if (width >= 1600) return 6;
    if (width >= 1300) return 5;
    if (width >= 1000) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  double _getChildAspectRatio(double screenWidth, int crossAxisCount) {
    double padding = 16 * 2;
    double spacing = 12 * (crossAxisCount - 1);
    double cardWidth = (screenWidth - padding - spacing) / crossAxisCount;
    double cardHeight = cardWidth * 0.8 + 120;
    return cardWidth / cardHeight;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, sizingInfo) {
            final screenWidth = sizingInfo.screenSize.width;
            final crossAxisCount = _getCrossAxisCount(screenWidth);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [Image.asset('assets/logo.png', height: 24)],
                    ),
                  ),
                ),
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
                const SliverToBoxAdapter(child: CategoryList()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                productState.when(
                  data: (products) {
                    // กรองเฉพาะสินค้าที่ status เป็น Available / Posted
                    final filteredProducts = products.where((p) {
                      final rawStatus = (p['status'] ?? '')
                          .toString()
                          .toLowerCase();
                      return rawStatus == 'available' ||
                          rawStatus == 'posted' ||
                          rawStatus == 'published';
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text('ยังไม่มีสินค้าที่พร้อมขาย')),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              ProductCard(product: filteredProducts[index]),
                          childCount: filteredProducts.length,
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
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => SliverToBoxAdapter(
                    child: Center(child: Text("Error: $err")),
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
