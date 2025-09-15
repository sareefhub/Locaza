import 'package:flutter/material.dart';
import 'package:frontend/data/dummy_products.dart';
import '../../../../core/widgets/product_card.dart';
import 'filter_screen.dart';
import '../../../../core/widgets/search_bar_all.dart';

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
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          initialFilters: _filters, // ส่งค่า filters ปัจจุบัน
        ),
      ),
    );

    if (filters != null) {
      setState(() {
        _filters =
            filters; // อัพเดทค่า filter แต่ไม่ล้างจนกว่าจะออกจากหน้า search
      });
    }
  }

  double _parsePrice(String priceString) {
    // ลบ '฿' และ ',' แล้วแปลงเป็น double
    final clean = priceString.replaceAll('฿', '').replaceAll(',', '');
    return double.tryParse(clean) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = dummyProducts.where((product) {
      final name = product['name']?.toString().toLowerCase() ?? '';
      final category = product['category']?.toString() ?? '';
      final location = product['location']?.toString() ?? '';
      final price = _parsePrice(product['price']?.toString() ?? '0');

      // ตรวจสอบ search query
      if (!name.contains(_searchQuery.toLowerCase())) return false;

      // ตรวจสอบ category filter
      if (_filters['category'] != null &&
          _filters['category'].toString().isNotEmpty &&
          category != _filters['category'])
        return false;

      // ตรวจสอบ location filter
      if (_filters['location'] != null &&
          _filters['location'].toString().isNotEmpty &&
          location != _filters['location'])
        return false;

      // ตรวจสอบ price range filter
      final minPrice =
          double.tryParse(_filters['minPrice'] ?? '') ??
          double.negativeInfinity;
      final maxPrice =
          double.tryParse(_filters['maxPrice'] ?? '') ?? double.infinity;
      if (price < minPrice || price > maxPrice) return false;

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
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("ไม่พบสินค้าที่ค้นหา"))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                        children: List.generate(filtered.length, (index) {
                          return ProductCard(product: filtered[index]);
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
