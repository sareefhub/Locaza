import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/api_config.dart';

class ChatHeader extends StatelessWidget {
  final Map<String, dynamic> product;
  final String currentUserId;
  final String otherUserName;
  final bool isSold;
  final bool isPurchased;
  final ValueChanged<bool> onSoldChanged;
  final ValueChanged<bool> onPurchasedChanged;

  const ChatHeader({
    super.key,
    required this.product,
    required this.currentUserId,
    required this.otherUserName,
    required this.isSold,
    required this.isPurchased,
    required this.onSoldChanged,
    required this.onPurchasedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final productTitle = product['title'] ?? 'ชื่อสินค้า';
    final productImageUrl =
        (product['image_urls'] != null && (product['image_urls'] as List).isNotEmpty)
            ? ApiConfig.fixUrl(product['image_urls'][0])
            : null;

    final sellerId = product['seller_id']?.toString();
    final isOwner = sellerId == currentUserId;

    String actionButtonText() {
      if (isOwner) return "ขาย";
      if (!isSold) return "ซื้อ";
      return isPurchased ? "รีวิวแล้ว" : "รีวิว";
    }

    void onActionPressed() {
      if (isOwner) {
        onSoldChanged(true);
      } else {
        if (!isSold) {
          return;
        }
        if (!isPurchased) {
          onPurchasedChanged(true);
          context.push('/review', extra: {
            "productId": product['id'],
            "buyerId": currentUserId,
          });
        }
      }
    }

    return AppBar(
      backgroundColor: const Color(0xFFC9E1E6),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Column(
          children: [
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
                  const CircleAvatar(
                    radius: 14,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    otherUserName.isNotEmpty ? otherUserName : 'ผู้ใช้ไม่ทราบชื่อ',
                    style: GoogleFonts.sarabun(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF062252),
                    ),
                  ),
                ],
              ),
            ),
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
                              image: NetworkImage(productImageUrl),
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
                      color: (isOwner || isSold)
                          ? const Color(0xFF62B9E8)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: onActionPressed,
                      child: Text(
                        actionButtonText(),
                        style: GoogleFonts.sarabun(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
