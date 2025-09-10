import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// mock data
final mockProducts = [
  {"name": "เสื้อผ้าแฟชั่น", "price": "250", "category": "เสื้อผ้า", "location": "กรุงเทพฯ"},
  {"name": "กระเป๋าหนังแท้", "price": "1200", "category": "เครื่องประดับ", "location": "เชียงใหม่"},
  {"name": "รองเท้าผ้าใบ", "price": "800", "category": "รองเท้า", "location": "หาดใหญ่"},
];

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
  Map<String, dynamic> _filters = {};

  void _onFilterPressed() {
    // UI only
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('ฟิลเตอร์'),
        content: Text('หน้านี้ยังเป็น mock UI'),
      ),
    );
  }

  void _onSortPressed() {
    // UI only
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('เรียงลำดับ'),
        content: Text('หน้านี้ยังเป็น mock UI'),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = mockProducts.where((product) {
      final name = product['name']!.toString().toLowerCase();
      final matchesSearch = name.contains(_searchQuery.toLowerCase());

      final category = _filters['category']?.toString() ?? '';
      final province = _filters['province']?.toString() ?? '';

      String priceStr = product['price']?.toString() ?? '0';
      priceStr = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
      final price = double.tryParse(priceStr) ?? 0;

      final minPrice = double.tryParse(_filters['minPrice'] ?? '') ?? 0;
      final maxPrice =
          double.tryParse(_filters['maxPrice'] ?? '') ?? double.infinity;

      final matchesCategory =
          category.isEmpty || product['category'] == category;
      final matchesProvince =
          province.isEmpty || product['location'] == province;
      final matchesPrice = price >= minPrice && price <= maxPrice;

      return matchesSearch && matchesCategory && matchesProvince && matchesPrice;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: SafeArea(
        child: Column(
          children: [
            // custom appbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
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
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "ค้นหาสินค้า...",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _onFilterPressed,
                      ),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: _onSortPressed,
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // product grid
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(child: Text("ไม่มีสินค้าสำหรับหมวดนี้"))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.70,
                        children: List.generate(filteredList.length, (index) {
                          final product = filteredList[index];
                          return _ProductCard(product: product);
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

// UI product card แบบง่าย (mock)
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Center(
                child: Icon(Icons.shopping_bag, size: 48, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product["name"] ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("฿${product["price"]}"),
          ],
        ),
      ),
    );
  }
}
