import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/api_config.dart';

class ChatHeader extends StatelessWidget {
  final Map<String, dynamic> product;
  final String currentUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final bool isSold;
  final bool isPurchased;
  final ValueChanged<bool> onSoldChanged;
  final ValueChanged<bool> onPurchasedChanged;

  const ChatHeader({
    super.key,
    required this.product,
    required this.currentUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
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
        ? ApiConfig.fixUrl(product['image_urls'][0])
        : null;

    final sellerId = product['seller_id']?.toString();
    final isOwner = sellerId == currentUserId;

    String actionButtonText() {
      if (isOwner) return "ขาย";
      if (!isSold) return "ซื้อ";
      return isPurchased ? "รีวิวแล้ว" : "รีวิว";
    }

    void onActionPressed(BuildContext context) async {
      if (isOwner) {
        // ผู้ขายกด "ขาย"
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ยืนยันการขาย"),
            content: const Text("คุณแน่ใจหรือไม่ว่าขายสินค้านี้แล้ว?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("ยืนยัน"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          onSoldChanged(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("ทำการขายสินค้าเรียบร้อย")),
          );
        }
      } else {
        // ผู้ซื้อ
        if (!isSold) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("รอผู้ขายทำการขายสินค้าก่อน")),
          );
          return;
        }

        if (!isPurchased) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ยืนยันการซื้อ"),
              content: const Text("คุณแน่ใจหรือไม่ว่าซื้อสินค้านี้แล้ว?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("ยกเลิก"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("ยืนยัน"),
                ),
              ],
            ),
          );

          if (confirm == true) {
            onPurchasedChanged(true);

            // แสดง dialog แจ้งรีวิว
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("สำเร็จ"),
                content: const Text(
                  "คุณซื้อสินค้าเรียบร้อยแล้ว สามารถไปรีวิวสินค้าได้",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ตกลง"),
                  ),
                ],
              ),
            );

            // ไปหน้ารีวิว
            context.push(
              '/review',
              extra: {"productId": product['id'], "buyerId": currentUserId},
            );
          }
        } else {
          // รีวิวแล้ว
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("แจ้งเตือน"),
              content: const Text("คุณได้รีวิวสินค้านี้แล้ว"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ตกลง"),
                ),
              ],
            ),
          );
        }
      }
    }

    return AppBar(
      backgroundColor: const Color(0xFFC9E1E6),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 120, // ✅ เพิ่มความสูงให้พอ
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ ป้องกัน Column ขยายเกิน
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2,
              ), // ✅ ลด vertical
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
                    radius: 14,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        (otherUserAvatar != null && otherUserAvatar!.isNotEmpty)
                        ? NetworkImage(ApiConfig.fixUrl(otherUserAvatar!))
                        : null,
                    child: (otherUserAvatar == null || otherUserAvatar!.isEmpty)
                        ? const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    otherUserName.isNotEmpty
                        ? otherUserName
                        : 'ผู้ใช้ไม่ทราบชื่อ',
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
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ), // ✅ ลด vertical
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ), // ✅ ลด vertical
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOwner
                          ? (isSold ? Colors.grey : const Color(0xFF62B9E8))
                          : (!isSold ? Colors.grey : const Color(0xFF62B9E8)),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if ((isOwner && isSold) || (!isOwner && !isSold)) return;
                      onActionPressed(context);
                    },
                    child: Text(
                      actionButtonText(),
                      style: GoogleFonts.sarabun(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
