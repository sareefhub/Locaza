import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/search_bar_category.dart';
import 'package:frontend/routing/routes.dart';
import '../../application/category_provider.dart';
import '../../application/product_provider.dart';

class CategoryProductListScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const CategoryProductListScreen({super.key, required this.categoryName});

  @override
  ConsumerState<CategoryProductListScreen> createState() =>
      _CategoryProductListScreenState();
}

class _CategoryProductListScreenState
    extends ConsumerState<CategoryProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String? _selectedLocation;
  String _minPrice = '';
  String _maxPrice = '';

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onFilterPressed() async {
    final initialFilter = {
      "category": widget.categoryName,
      "location": _selectedLocation ?? "",
      "minPrice": _minPrice,
      "maxPrice": _maxPrice,
    };

    final result = await context.push<Map<String, dynamic>>(
      AppRoutes.filter,
      extra: initialFilter,
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result["location"]?.toString().isEmpty ?? true
            ? null
            : result["location"];
        _minPrice = result["minPrice"]?.toString() ?? '';
        _maxPrice = result["maxPrice"]?.toString() ?? '';
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
    final categories = ref.watch(categoryListProvider);
    final products = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: categories.when(
          data: (categoryData) {
            final category = categoryData.firstWhere(
              (c) => c['name'] == widget.categoryName,
              orElse: () => {},
            );
            final categoryId = category['id'];

            return products.when(
              data: (productData) {
                final filteredProducts = productData.where((product) {
                  final productTitle =
                      product['title']?.toString().toLowerCase() ?? '';
                  final productCategoryId = product['category_id'];
                  final productLocation = product['location']?.toString() ?? '';
                  final productPrice =
                      (product['price'] as num?)?.toInt() ?? 0;

                  final minPriceInt = int.tryParse(
                          _minPrice.replaceAll(RegExp(r'[^\d]'), '')) ??
                      0;
                  final maxPriceInt = int.tryParse(
                          _maxPrice.replaceAll(RegExp(r'[^\d]'), '')) ??
                      9999999;

                  final matchesCategory = productCategoryId == categoryId;
                  final matchesLocation = _selectedLocation != null
                      ? productLocation == _selectedLocation
                      : true;
                  final matchesMinPrice = productPrice >= minPriceInt;
                  final matchesMaxPrice = productPrice <= maxPriceInt;
                  final matchesSearch =
                      productTitle.contains(_searchQuery.toLowerCase());

                  final matchesStatus = product['status'] == 'available';

                  return matchesCategory &&
                      matchesLocation &&
                      matchesMinPrice &&
                      matchesMaxPrice &&
                      matchesSearch &&
                      matchesStatus;
                }).toList();

                return Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Center(
                            child: Text(
                              widget.categoryName,
                              style: GoogleFonts.sarabun(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
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
                    SearchFilterBar(
                      searchController: _searchController,
                      onSearchChanged: _onSearchChanged,
                      onFilterPressed: _onFilterPressed,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: filteredProducts.isEmpty
                          ? Center(
                              child: Text(
                                "ไม่มีสินค้าสำหรับหมวดหมู่นี้",
                                style: GoogleFonts.sarabun(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : ResponsiveBuilder(
                              builder: (context, sizingInfo) {
                                final screenWidth =
                                    sizingInfo.screenSize.width;
                                final crossAxisCount =
                                    _getCrossAxisCount(screenWidth);
                                final aspectRatio = _getChildAspectRatio(
                                    screenWidth, crossAxisCount);

                                return CustomScrollView(
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      sliver: SliverGrid(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final product =
                                                filteredProducts[index];
                                            return ProductCard(
                                                product: product);
                                          },
                                          childCount: filteredProducts.length,
                                        ),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: aspectRatio,
                                        ),
                                      ),
                                    ),
                                    const SliverToBoxAdapter(
                                      child: SizedBox(height: 80),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, _) => Center(child: Text("Error: $err")),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
