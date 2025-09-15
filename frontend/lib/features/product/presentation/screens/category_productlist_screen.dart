import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../data/dummy_products.dart';
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
  String? _selectedCategory;
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
      "category": widget.categoryName, // category ปัจจุบัน
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
        // category จะถูกบังคับให้เท่ากับหน้าปัจจุบันเสมอ
        _selectedCategory = widget.categoryName;

        // ส่วนอื่น ๆ รับค่าจาก FilterScreen ตามปกติ
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
    final filteredProducts = dummyProducts.where((product) {
      final productName = product['name']?.toString().toLowerCase() ?? '';
      final productCategory = product['category']?.toString() ?? '';
      final productLocation = product['location']?.toString() ?? '';

      // แปลงราคาเป็น int
      final priceString =
          product['price']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0';
      final productPrice = int.tryParse(priceString) ?? 0;

      final minPriceInt =
          int.tryParse(_minPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final maxPriceInt =
          int.tryParse(_maxPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 9999999;

      final matchesCategory = _selectedCategory != null
          ? productCategory == _selectedCategory
          : productCategory == widget.categoryName;

      final matchesLocation = _selectedLocation != null
          ? productLocation == _selectedLocation
          : true;

      final matchesMinPrice = productPrice >= minPriceInt;
      final matchesMaxPrice = productPrice <= maxPriceInt;

      final matchesSearch = productName.contains(_searchQuery.toLowerCase());

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
                  ? const Center(child: Text("ไม่มีสินค้าสำหรับหมวดหมู่นี้"))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                        children: List.generate(filteredProducts.length, (
                          index,
                        ) {
                          final product = filteredProducts[index];
                          return ProductCard(product: product);
                        }),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
