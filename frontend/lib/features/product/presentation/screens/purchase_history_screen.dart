import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/widgets/purchase_card.dart';
import 'package:frontend/core/widgets/custom_search_bar.dart';
import '../../application/purchase_provider.dart';
import '../../../../utils/user_session.dart';
import '../../../../config/api_config.dart';

class MyPurchasePage extends ConsumerStatefulWidget {
  const MyPurchasePage({super.key});

  @override
  ConsumerState<MyPurchasePage> createState() => _MyPurchasePageState();
}

class _MyPurchasePageState extends ConsumerState<MyPurchasePage> {
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  String _buildImageUrl(dynamic raw) {
    if (raw == null) return "";
    if (raw is List && raw.isNotEmpty) return ApiConfig.fixUrl(raw.first.toString());
    if (raw is String) return ApiConfig.fixUrl(raw);
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final userId = int.tryParse(UserSession.id ?? "0") ?? 0;
    final purchasesAsync = ref.watch(purchaseListProvider(userId));

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
            context.go('/profile');
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
          Expanded(
            child: purchasesAsync.when(
              data: (purchases) {
                final filtered = purchases.where((p) {
                  final title = (p['product_title'] ?? "").toString().toLowerCase();
                  return title.contains(searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("ยังไม่มีประวัติการซื้อ"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final imageUrl = _buildImageUrl(item['image_url']);

                    return Column(
                      children: [
                        PurchaseCard(
                          seller: item['seller_name'] ?? 'ไม่ทราบผู้ขาย',
                          productName: item['product_title'] ?? '',
                          time: (item['created_at'] ?? '').toString(),
                          price: "฿${item['price'] ?? ''}",
                          status: item['status'] ?? '',
                          imageUrl: imageUrl,
                          product: item,
                        ),
                        const SizedBox(height: 2),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ),
        ],
      ),
    );
  }
}
