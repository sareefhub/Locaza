import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/product_card.dart';
import 'filter_screen.dart';
import '../../../../core/widgets/search_bar_all.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend/features/product/application/product_provider.dart';
import 'package:frontend/features/product/application/category_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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
    final productsState = ref.watch(productListProvider);
    final categoriesState = ref.watch(categoryListProvider);

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
        child: productsState.when(
          data: (products) {
            final categories = categoriesState.maybeWhen(
              data: (data) => data,
              orElse: () => [],
            );

            final filtered = products.where((product) {
              final title = product['title']?.toString().toLowerCase() ?? '';
              final categoryId = product['category_id'];
              final location = product['location']?.toString() ?? '';
              final price = double.tryParse(product['price'].toString()) ?? 0;

              if (product['status'] != 'available') return false;
              if (!title.contains(_searchQuery.toLowerCase())) return false;
              if (_filters['category_id'] != null) {
                if (_filters['category_id'] != categoryId) return false;
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

            if (filtered.isEmpty) {
              return Center(
                child: Text(
                  "ไม่พบสินค้าที่ค้นหา",
                  style: GoogleFonts.sarabun(fontSize: 16),
                ),
              );
            }

            return ResponsiveBuilder(
              builder: (context, sizingInfo) {
                final screenWidth = sizingInfo.screenSize.width;
                final crossAxisCount = _getCrossAxisCount(screenWidth);
                final childAspectRatio =
                    _getChildAspectRatio(screenWidth, crossAxisCount);

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = filtered[index];
                            final category = categories.firstWhere(
                              (c) => c['id'] == product['category_id'],
                              orElse: () => {'name': ''},
                            );
                            final categoryName = category['name'].toString();
                            final productWithCategory = {
                              ...product,
                              'categoryName': categoryName,
                            };
                            return ProductCard(product: productWithCategory);
                          },
                          childCount: filtered.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (err, _) =>
              Center(child: Text("โหลดสินค้าไม่ได้: $err")),
        ),
      ),
    );
  }
}
