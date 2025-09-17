import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/data/dummy_products.dart';
import 'package:frontend/data/dummy_users.dart';
import 'package:go_router/go_router.dart';

class MyPurchasePage extends StatefulWidget {
  const MyPurchasePage({super.key});

  @override
  State<MyPurchasePage> createState() => _MyPurchasePageState();
}

class _MyPurchasePageState extends State<MyPurchasePage> {
  String searchQuery = "";

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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: GoogleFonts.sarabun(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                hintText: "ค้นหาสินค้า...",
                hintStyle: GoogleFonts.sarabun(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // ทำให้มน
                  borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.blueAccent, // ขอบเมื่อโฟกัส
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

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
                    const SizedBox(height: 10),
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

class PurchaseCard extends StatelessWidget {
  final String seller;
  final String productName;
  final String time;
  final String price;
  final String status;
  final String imageUrl;

  const PurchaseCard({
    super.key,
    required this.seller,
    required this.productName,
    required this.time,
    required this.price,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ชื่อร้าน-สถานะ
              Row(
                children: [
                  const Icon(Icons.store, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      seller,
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: GoogleFonts.sarabun(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // รูป-ชื่อสินค้า/เวลา-ราคา
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปสินค้า
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(imageUrl, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.image, size: 30, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),

                  // ชื่อสินค้า - เวลา
                  SizedBox(
                    height: 70, // ความสูงเท่ารูป
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ชื่อสินค้าอยู่บน
                        Text(
                          productName,
                          style: GoogleFonts.sarabun(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(), // ดันเวลาไปชิดล่าง
                        Text(
                          time,
                          style: GoogleFonts.sarabun(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ราคา ชิดขอบล่าง
                  SizedBox(
                    height: 70,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        price,
                        style: GoogleFonts.sarabun(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
