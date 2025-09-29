import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/navigation.dart';
import '../../application/notification_provider.dart';
import '../../../../config/api_config.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  String _mapTypeToText(String type) {
    switch (type) {
      case "new_product":
        return "สินค้าใหม่";
      case "product_sold":
        return "สินค้าขายแล้ว";
      case "price_update":
        return "อัพเดตราคา";
      case "message":
        return "ข้อความใหม่";
      default:
        return "แจ้งเตือน";
    }
  }

  IconData _mapTypeToIcon(String type) {
    switch (type) {
      case "new_product":
        return Icons.new_releases_outlined;
      case "product_sold":
        return Icons.shopping_bag_outlined;
      case "price_update":
        return Icons.attach_money_outlined;
      case "message":
        return Icons.chat_bubble_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm', 'th').format(date);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: notificationsState.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'ยังไม่มีการแจ้งเตือน',
                style: GoogleFonts.sarabun(fontSize: 16, color: Colors.black54),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(notificationProvider.notifier).fetchNotifications();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return _NotificationCard(
                  title: n["content"] ?? "-",
                  subtitle: _mapTypeToText(n["type"] ?? "-"),
                  timeText: n["created_at"] != null
                      ? _formatDate(n["created_at"])
                      : "",
                  imageUrl: (n["product"]?["image_urls"] != null &&
                          (n["product"]["image_urls"] as List).isNotEmpty)
                      ? ApiConfig.fixUrl(n["product"]["image_urls"][0])
                      : null,
                  isRead: n["is_read"] ?? false,
                  icon: _mapTypeToIcon(n["type"] ?? ""),
                  onTap: () {
                    ref.read(notificationProvider.notifier).markAsRead(n["id"]);
                    if (n["product"] != null) {
                      final productId = n["product"]["id"];
                      if (productId != null) {
                        context.push('/product_details/$productId');
                      }
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            "เกิดข้อผิดพลาด: $err",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFE0F3F7),
      centerTitle: true,
      elevation: 0,
      title: Text(
        'แจ้งเตือน',
        style: GoogleFonts.sarabun(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.notifications_outlined, color: Colors.black),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.timeText,
    this.imageUrl,
    required this.isRead,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String timeText;
  final String? imageUrl;
  final bool isRead;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isRead ? const Color(0xFFE6E6E6) : const Color(0xFFD1E9F2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImagePlaceholder(imageUrl: imageUrl, icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: _Texts(
                  title: title,
                  subtitle: subtitle,
                  timeText: timeText,
                  isRead: isRead,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isRead ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isRead ? Colors.green : Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.imageUrl, required this.icon});
  final String? imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(8);
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: border,
        child: Image.network(
          imageUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: border,
      ),
      child: Icon(icon, color: Colors.blueGrey, size: 28),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.isRead,
  });

  final String title;
  final String subtitle;
  final String timeText;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.sarabun(
            fontSize: 13,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          timeText,
          style: GoogleFonts.sarabun(
            fontSize: 12,
            color: isRead ? Colors.black38 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
