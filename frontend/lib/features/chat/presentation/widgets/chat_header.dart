import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/dummy_users.dart';

class ChatHeader extends StatelessWidget {
  final Map<String, dynamic> product;
  final String currentUserId;
  final bool isSold;
  final bool isPurchased;
  final ValueChanged<bool> onSoldChanged;
  final ValueChanged<bool> onPurchasedChanged;

  const ChatHeader({
    super.key,
    required this.product,
    required this.currentUserId,
    required this.isSold,
    required this.isPurchased,
    required this.onSoldChanged,
    required this.onPurchasedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final productTitle = product['title'] ?? 'ชื่อสินค้า';
    final productImageUrl =
        (product['image_urls'] != null &&
            (product['image_urls'] as List).isNotEmpty)
        ? product['image_urls'][0]
        : null;

    final sellerId = product['seller_id'];
    final seller = dummyUsers.firstWhere(
      (user) => user['id'] == sellerId,
      orElse: () => {'name': 'ผู้ขายไม่ทราบชื่อ', 'avatar_url': null},
    );
    final sellerName = seller['name'];
    final sellerAvatar = seller['avatar_url'];
    final isOwner = currentUserId == sellerId.toString();

    String actionButtonText() {
      if (isOwner) return "ขาย";
      if (!isSold) return "ซื้อ";
      return isPurchased ? "รีวิว" : "ซื้อ";
    }

    return AppBar(
      backgroundColor: const Color(0xFFC9E1E6),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Column(
          children: [
            // --- Header แสดงชื่อผู้ขาย ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/angle-small-left.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    backgroundImage: sellerAvatar != null
                        ? AssetImage(sellerAvatar)
                        : null,
                    child: sellerAvatar == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    sellerName,
                    style: GoogleFonts.sarabun(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF062252),
                    ),
                  ),
                ],
              ),
            ),
            // --- Header แสดงสินค้า ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: productImageUrl != null
                          ? DecorationImage(
                              image: AssetImage(productImageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: productImageUrl == null
                        ? const Icon(Icons.image, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      productTitle,
                      style: GoogleFonts.sarabun(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF062252),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOwner
                          ? const Color(0xFFE0AFAF)
                          : (!isSold ? Colors.grey : const Color(0xFF62B9E8)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      actionButtonText(),
                      style: GoogleFonts.sarabun(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
