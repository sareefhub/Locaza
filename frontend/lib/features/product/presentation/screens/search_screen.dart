import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/dummy_products.dart';
import 'package:frontend/data/dummy_categories.dart';
import 'package:frontend/data/dummy_users.dart';
import '../../../../core/widgets/product_card.dart';
import 'filter_screen.dart';
import '../../../../core/widgets/search_bar_all.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onFilterPressed() async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => FilterScreen(initialFilters: _filters)),
    );

    if (filters != null) {
      setState(() {
        _filters = filters;
      });
    }
  }

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
  Widget build(BuildContext context) {
    final filtered = dummyProducts.where((product) {
      final title = product['title']?.toString().toLowerCase() ?? '';
      final categoryId = product['category_id'];
      final location = product['location']?.toString() ?? '';
      final price = product['price'] as double? ?? 0;

      if (product['status'] != 'available') return false;
      if (!title.contains(_searchQuery.toLowerCase())) return false;
      if (_filters['category'] != null &&
          _filters['category'].toString().isNotEmpty) {
        final category = dummyCategories.firstWhere(
          (c) => c['label'] == _filters['category'],
          orElse: () => {},
        );
        if (category['id'] != categoryId) return false;
      }
      if (_filters['location'] != null &&
          _filters['location'].toString().isNotEmpty) {
        if (location != _filters['location']) return false;
      }
      double? minPrice = double.tryParse(
        _filters['minPrice']?.toString().trim() ?? '',
      );
      double? maxPrice = double.tryParse(
        _filters['maxPrice']?.toString().trim() ?? '',
      );
      if (minPrice != null && price < minPrice) return false;
      if (maxPrice != null && price > maxPrice) return false;

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: SearchBarAll(
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          onFilterPressed: _onFilterPressed,
        ),
      ),
      body: SafeArea(
        child: filtered.isEmpty
            ? Center(
                child: Text(
                  "ไม่พบสินค้าที่ค้นหา",
                  style: GoogleFonts.sarabun(fontSize: 16),
                ),
              )
            : ResponsiveBuilder(
                builder: (context, sizingInfo) {
                  final screenWidth = sizingInfo.screenSize.width;
                  final crossAxisCount = _getCrossAxisCount(screenWidth);
                  final childAspectRatio = _getChildAspectRatio(
                    screenWidth,
                    crossAxisCount,
                  );

                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = filtered[index];
                            final seller = dummyUsers.firstWhere(
                              (u) => u['id'] == product['seller_id'],
                              orElse: () => {},
                            );
                            product['sellerName'] =
                                seller['name'] ?? 'ไม่ทราบชื่อผู้ขาย';
                            product['sellerImage'] = seller['avatar_url'] ?? '';

                            return ProductCard(product: product);
                          }, childCount: filtered.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: childAspectRatio,
                              ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
