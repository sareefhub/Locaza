import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/api_config.dart';
import '../../../product/infrastructure/product_api.dart';

class ChatHeader extends StatelessWidget {
  final Map<String, dynamic> product;
  final String currentUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final ValueChanged<String> onStatusChanged;

  const ChatHeader({
    super.key,
    required this.product,
    required this.currentUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.onStatusChanged,
  });

  Future<void> _updateProductStatus(
      BuildContext context, int productId, String newStatus) async {
    try {
      final api = ProductApi();
      await api.updateProductStatus(productId, newStatus);
      onStatusChanged(newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("อัพเดตสถานะสินค้าเป็น $newStatus สำเร็จ")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("อัพเดตสถานะล้มเหลว: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productTitle = product['title'] ?? 'ชื่อสินค้า';
    final productImageUrl =
        (product['image_urls'] != null && (product['image_urls'] as List).isNotEmpty)
            ? ApiConfig.fixUrl(product['image_urls'][0])
            : null;

    final sellerId = product['seller_id']?.toString();
    final isOwner = sellerId == currentUserId;
    final productId = int.tryParse(product['id']?.toString() ?? '');
    final status = product['status']?.toString() ?? 'available';

    String actionButtonText() {
      if (isOwner) {
        if (status == "available") return "ขาย";
        if (status == "reserved") return "ขายแล้ว";
        return "ขายแล้ว";
      } else {
        if (status == "reserved") return "ซื้อ";
        if (status == "sold") return "รีวิว";
        return "รีวิวแล้ว";
      }
    }

    void onActionPressed(BuildContext context) async {
      if (productId == null) return;
      if (isOwner) {
        if (status == "available") {
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
            await _updateProductStatus(context, productId, "reserved");
          }
        }
      } else {
        if (status == "reserved") {
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
            await _updateProductStatus(context, productId, "sold");
          }
        } else if (status == "sold") {
          context.push(
            '/review',
            extra: {"productId": productId, "buyerId": currentUserId},
          );
        }
      }
    }

    return AppBar(
      backgroundColor: const Color(0xFFC9E1E6),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 120,
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2,
              ),
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
                    backgroundImage: (otherUserAvatar != null && otherUserAvatar!.isNotEmpty)
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
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
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
                      backgroundColor: (actionButtonText() == "-" ? Colors.grey : const Color(0xFF62B9E8)),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: actionButtonText() == "-" || actionButtonText() == "ขายแล้ว"
                        ? null
                        : () => onActionPressed(context),
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
