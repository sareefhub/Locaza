import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/dummy_products.dart';
import 'package:frontend/data/dummy_users.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/widgets/purchase_card.dart';
import 'package:frontend/core/widgets/custom_search_bar.dart';

class MyPurchasePage extends StatefulWidget {
  const MyPurchasePage({super.key});

  @override
  State<MyPurchasePage> createState() => _MyPurchasePageState();
}

class _MyPurchasePageState extends State<MyPurchasePage> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // กรองสินค้าตาม search
    final soldProducts = dummyProducts
        .where(
          (p) =>
              p['status'] == 'sold' &&
              (p['title'] as String).toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD1E9F2),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/angle-small-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            context.go('/profile'); // ไปหน้า Profile ใหม่
          },
        ),
        centerTitle: true,
        title: Text(
          "การซื้อของฉัน",
          style: GoogleFonts.sarabun(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CustomSearchBar(
              hintText: "ค้นหาสินค้า",
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // List สินค้า
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: soldProducts.length,
              itemBuilder: (context, index) {
                final product = soldProducts[index];

                // หาผู้ขาย
                final seller = dummyUsers.firstWhere(
                  (user) => user['id'] == product['seller_id'],
                  orElse: () => {'name': 'ไม่ทราบผู้ขาย'},
                );

                return Column(
                  children: [
                    PurchaseCard(
                      seller: seller['name'],
                      productName: product['title'],
                      time: "วันนี้ 10:45 น.",
                      price: "฿${product['price'].toStringAsFixed(0)}",
                      status: "สั่งซื้อสำเร็จ",
                      imageUrl: product['image_urls'].isNotEmpty
                          ? product['image_urls'][0]
                          : '',
                    ),
                    const SizedBox(height: 2),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
