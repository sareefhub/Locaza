import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> mockProducts = [
    {
      "id": "1",
      "name": "มะม่วงออร์แกนิก",
      "category": "อาหารสด",
      "location": "เชียงใหม่",
      "price": "฿120",
      "image": "assets/products-image/mango.jpg",
    },
    {
      "id": "2",
      "name": "ตะกร้าสานไม้ไผ่",
      "category": "งานหัตถกรรม",
      "location": "ลำปาง",
      "price": "฿250",
      "image": "assets/products-image/basket.jpg",
    },
    {
      "id": "3",
      "name": "หมึกกล้วย",
      "category": "อาหารสด",
      "location": "สงขลา",
      "price": "฿280",
      "image": "assets/products-image/squid.jpeg",
    },
  ];

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onFilterPressed() async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const FilterScreen(),
      ),
    );

    if (filters != null) {
      setState(() {
        _filters = filters;
      });
    }
  }

  void _onSortPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("เรียงลำดับ (Mock UI)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = mockProducts.where((product) {
      final name = product['name']?.toString().toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
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
          onSortPressed: _onSortPressed,
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
                        childAspectRatio: 0.60,
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
