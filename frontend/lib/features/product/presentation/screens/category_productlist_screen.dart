import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../data/dummy_products.dart';
import '../../../../data/dummy_categories.dart';
import '../../../../data/dummy_users.dart';
import '../../../../core/widgets/search_bar_category.dart';
import 'package:frontend/routing/routes.dart';

class CategoryProductListScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductListScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductListScreen> createState() =>
      _CategoryProductListScreenState();
}

class _CategoryProductListScreenState extends State<CategoryProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // เก็บค่า filter ปัจจุบัน
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

  @override
  Widget build(BuildContext context) {
    // หา category id จากชื่อ category
    final category = dummyCategories.firstWhere(
      (c) => c['label'] == widget.categoryName,
      orElse: () => {},
    );
    final categoryId = category['id'];

    final filteredProducts = dummyProducts.where((product) {
      final productTitle = product['title']?.toString().toLowerCase() ?? '';
      final productCategoryId = product['category_id'];
      final productLocation = product['location']?.toString() ?? '';

      final productPrice = (product['price'] as num?)?.toInt() ?? 0;

      final minPriceInt =
          int.tryParse(_minPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final maxPriceInt =
          int.tryParse(_maxPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 9999999;

      final matchesCategory = productCategoryId == categoryId;
      final matchesLocation = _selectedLocation != null
          ? productLocation == _selectedLocation
          : true;
      final matchesMinPrice = productPrice >= minPriceInt;
      final matchesMaxPrice = productPrice <= maxPriceInt;
      final matchesSearch = productTitle.contains(_searchQuery.toLowerCase());

      return matchesCategory &&
          matchesLocation &&
          matchesMinPrice &&
          matchesMaxPrice &&
          matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: Column(
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
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                        children: filteredProducts.map((product) {
                          // ดึง seller info จาก dummyUsers
                          final seller = dummyUsers.firstWhere(
                            (u) => u['id'] == product['seller_id'],
                            orElse: () => {},
                          );
                          product['sellerName'] =
                              seller['name'] ?? 'ไม่ทราบชื่อผู้ขาย';
                          product['sellerImage'] = seller['avatar_url'] ?? '';

                          return ProductCard(product: product);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
