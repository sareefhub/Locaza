import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/api_config.dart';
import '../../../product/infrastructure/product_api.dart';
import '../../../product/infrastructure/purchase_api.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> product;
  final String currentUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final ValueChanged<String> onStatusChanged;

  @override
  final Size preferredSize;

  const ChatHeader({
    super.key,
    required this.product,
    required this.currentUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.onStatusChanged,
  }) : preferredSize = const Size.fromHeight(120);

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

  Future<Map<String, dynamic>?> _createPurchaseHistory(
      BuildContext context, int productId, int sellerId, int chatroomId) async {
    try {
      final api = PurchaseApi();
      final data = {
        "product_id": productId,
        "buyer_id": int.parse(currentUserId),
        "seller_id": sellerId,
        "chatroom_id": chatroomId,
        "status": "completed"
      };
      final created = await api.createPurchase(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("สร้างประวัติการซื้อสำเร็จ")),
      );
      return created;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("สร้างประวัติการซื้อล้มเหลว: $e")),
      );
      return null;
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
    final chatroomId = int.tryParse(product['chatroom_id']?.toString() ?? '0') ?? 0;
    final isOwner = sellerId == currentUserId;
    final productId = int.tryParse(product['id']?.toString() ?? '');
    final status = product['status']?.toString() ?? 'available';

    String actionButtonText() {
      if (isOwner) {
        if (status == "available") return "ขาย";
        if (status == "reserved") return "กำลังขาย";
        return "ขายแล้ว";
      } else {
        if (status == "reserved") return "ซื้อ";
        if (status == "sold") return "รีวิว";
        return "ซื้อ";
      }
    }

    bool isButtonEnabled() {
      if (isOwner) {
        return status == "available";
      } else {
        return status == "reserved" || status == "sold";
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
            final transaction = await _createPurchaseHistory(
                context, productId, int.parse(sellerId ?? '0'), chatroomId);
            if (transaction != null) {
              context.push(
                '/review',
                extra: {
                  "storeName": otherUserName,
                  "product": product,
                  "reviewerId": currentUserId,
                  "revieweeId": sellerId,
                  "saleTransactionId": transaction['id'],
                },
              );
            }
          }
        } else if (status == "sold") {
          var transactionId = product['transaction_id'];
          if (transactionId == null) {
            final purchase = await PurchaseApi()
                .getPurchaseByProduct(productId, int.parse(currentUserId));
            transactionId = purchase?['id'];
          }
          if (transactionId != null) {
            context.push(
              '/review',
              extra: {
                "storeName": otherUserName,
                "product": product,
                "reviewerId": currentUserId,
                "revieweeId": sellerId,
                "saleTransactionId": transactionId,
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("ไม่พบข้อมูลการซื้อ-ขาย")),
            );
          }
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
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
                    backgroundImage: (otherUserAvatar?.isNotEmpty ?? false)
                        ? NetworkImage(ApiConfig.fixUrl(otherUserAvatar!))
                        : null,
                    child: (otherUserAvatar?.isEmpty ?? true)
                        ? const Icon(Icons.person, size: 16, color: Colors.white)
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
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      backgroundColor: isButtonEnabled() ? const Color(0xFF62B9E8) : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: isButtonEnabled() ? () => onActionPressed(context) : null,
                    child: Text(
                      actionButtonText(),
                      style: GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.bold),
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
