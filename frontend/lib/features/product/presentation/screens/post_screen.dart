import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/widgets/navigation.dart';
import 'package:frontend/config/api_config.dart';
import '../../../../utils/user_session.dart';
import '../../application/product_provider.dart';

extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
}

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});
  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  Future<bool?> _confirmDelete() => showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'ยืนยันการลบ',
        style: GoogleFonts.sarabun(fontWeight: FontWeight.bold),
      ),
      content: Text(
        'คุณต้องการลบโพสต์นี้หรือไม่?',
        style: GoogleFonts.sarabun(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('ยกเลิก', style: GoogleFonts.sarabun()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text('ลบ', style: GoogleFonts.sarabun(color: Colors.red)),
        ),
      ],
    ),
  );

  String? _firstImage(dynamic raw) {
    if (raw == null) return null;
    if (raw is List && raw.isNotEmpty)
      return ApiConfig.fixUrl(raw.first.toString());
    if (raw is String && raw.isNotEmpty) {
      final urls = raw
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',');
      return urls.isNotEmpty ? ApiConfig.fixUrl(urls.first.trim()) : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userId = int.tryParse(UserSession.id ?? "0") ?? 0;
    final productsAsync = ref.watch(productListByUserProvider(userId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        title: Text(
          'โพสต์',
          style: GoogleFonts.sarabun(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => context.push('/choose_photo'),
          ),
        ],
        elevation: 0,
      ),
      body: productsAsync.when(
        data: (posts) {
          // แปลง status และกรองเฉพาะ Sold ออก
          final filteredPosts = posts.where((p) {
            final rawStatus = (p['status'] ?? '').toString().toLowerCase();
            return rawStatus != 'sold'; // ไม่เอา Sold
          }).toList();

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text('ยังไม่มีโพสต์', style: GoogleFonts.sarabun()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productListByUserProvider(userId));
            },
            child: ListView.builder(
              itemCount: filteredPosts.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, i) {
                final p = filteredPosts[i];
                final firstImage = _firstImage(p['image_urls']);

                // แปลงค่า status เป็น Posted / Draft
                final rawStatus = (p['status'] ?? '').toString().toLowerCase();
                final displayStatus =
                    (rawStatus == 'available' ||
                        rawStatus == 'posted' ||
                        rawStatus == 'published')
                    ? 'Posted'
                    : 'Draft';

                return GestureDetector(
                  onTap: () => context.push('/postedit/${p['id']}'),
                  child: _postItem(
                    p['title'] ?? '',
                    p['description'] ?? '',
                    displayStatus,
                    DateTime.tryParse(p['created_at']?.toString() ?? '') ??
                        DateTime.now(),
                    p['id'].toString(),
                    firstImage,
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('เกิดข้อผิดพลาด: $err', style: GoogleFonts.sarabun()),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _postItem(
    String name,
    String desc,
    String status,
    DateTime created,
    String id,
    String? img,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: img != null && img.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  )
                : const Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.sarabun(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _statusLabel(status),
                    const SizedBox(width: 8),
                    Text(
                      "${created.day}/${created.month}/${created.year}",
                      style: GoogleFonts.sarabun(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onSelected: (v) async {
              if (v == 'edit') {
                await context.push('/postedit/$id');
                ref.invalidate(
                  productListByUserProvider(
                    int.tryParse(UserSession.id ?? "0") ?? 0,
                  ),
                );
              } else if (v == 'delete' && await _confirmDelete() == true) {
                final success = await ref
                    .read(productApiProvider)
                    .deleteProduct(int.parse(id));
                if (success) {
                  ref.invalidate(
                    productListByUserProvider(
                      int.tryParse(UserSession.id ?? "0") ?? 0,
                    ),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '✅ ลบโพสต์เรียบร้อย',
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '❌ ลบโพสต์ไม่สำเร็จ',
                          style: GoogleFonts.sarabun(),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 18),
                    const SizedBox(width: 8),
                    Text('แก้ไข', style: GoogleFonts.sarabun()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ลบโพสต์',
                      style: GoogleFonts.sarabun(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _statusLabel(String status) {
    Color bg;
    switch (status) {
      case 'Posted':
        bg = const Color(0xFFB9E8C9); // เขียวอ่อน
        break;
      case 'Draft':
        bg = const Color(0xFFFFF5C2); // เหลืองอ่อน
        break;
      default:
        bg = const Color(0xFFDCEFF3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF062252)),
      ),
      child: Text(
        status,
        style: GoogleFonts.sarabun(fontSize: 12, color: Colors.black),
      ),
    );
  }
}
