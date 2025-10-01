import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/widgets/province_picker.dart';
import '../../../../utils/user_session.dart';
import '../../../../config/api_config.dart';
import '../../application/product_provider.dart';
import '../../application/category_provider.dart';

class EditPostFormScreen extends ConsumerStatefulWidget {
  final int postId;
  const EditPostFormScreen({super.key, required this.postId});

  @override
  ConsumerState<EditPostFormScreen> createState() => _EditPostFormScreenState();
}

class _EditPostFormScreenState extends ConsumerState<EditPostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final detailCtrl = TextEditingController();
  String? _category, _province, _status;
  int? _categoryId;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = await ref.read(productApiProvider).getProductById(widget.postId);
    if (product != null) {
      final categories = await ref.read(categoryListProvider.future);
      Map<String, dynamic>? cat;
      try {
        cat = categories.firstWhere((c) => c['id'] == product['category_id']);
      } catch (e) {
        cat = null;
      }
      setState(() {
        nameCtrl.text = product['title'] ?? '';
        priceCtrl.text = product['price']?.toString() ?? '';
        detailCtrl.text = product['description'] ?? '';
        _categoryId = product['category_id'];
        _category = cat?['name'] ?? '';
        _province = product['location'] ?? '';
        _status = product['status'] ?? '';
        if (product['image_urls'] is List) {
          _images = (product['image_urls'] as List).map<String>((e) {
            final s = e.toString();
            if (s.startsWith('http')) return s;
            return "${ApiConfig.baseUrl.replaceAll('/api/v1', '')}$s";
          }).toList();
        } else if (product['image_urls'] is String) {
          final s = product['image_urls'];
          _images = [s.startsWith('http') ? s : "${ApiConfig.baseUrl.replaceAll('/api/v1', '')}$s"];
        }
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(maxWidth: 1600);
    if (picked.isNotEmpty) {
      setState(() {
        _images = picked.take(5).map((e) => e.path).toList();
      });
    }
  }

  Future<void> _saveProduct(String state) async {
    if (!_formKey.currentState!.validate()) return;
    List<String> uploaded = [];
    for (final img in _images) {
      if (img.isNotEmpty && !img.startsWith('http')) {
        final url = await ref.read(productApiProvider).uploadProductImage(File(img));
        if (url != null) uploaded.add(url);
      } else {
        if (img.isNotEmpty) {
          final uri = Uri.parse(img);
          uploaded.add(uri.path);
        }
      }
    }
    final product = {
      "seller_id": int.parse(UserSession.id ?? "1"),
      "title": nameCtrl.text.trim(),
      "description": detailCtrl.text.trim(),
      "price": double.tryParse(priceCtrl.text.trim()) ?? 0.0,
      "category_id": _categoryId ?? 1,
      "location": _province ?? "",
      "status": state == 'post' ? (_status ?? 'available') : 'draft',
      "image_urls": uploaded
    };
    await ref.read(productApiProvider).updateProduct(widget.postId, product);
    final userId = int.tryParse(UserSession.id ?? "0") ?? 0;
    ref.invalidate(productListByUserProvider(userId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state == 'post' ? '✅ เผยแพร่โพสต์เรียบร้อย' : '✅ บันทึกการแก้ไขเรียบร้อย', style: GoogleFonts.sarabun())),
    );
    context.go('/post');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    detailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        leading: const BackButton(color: Colors.black),
        title: Text('แก้ไขโพสต์', style: GoogleFonts.sarabun(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _saveProduct('draft'),
            child: Text('บันทึกแบบร่าง', style: GoogleFonts.sarabun(color: Colors.black)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_images.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (c, i) {
                      final img = _images[i];
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: img.startsWith('http')
                              ? Image.network(img, width: 100, height: 100, fit: BoxFit.cover)
                              : Image.file(File(img), width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              TextButton(
                onPressed: _pickImages,
                child: Text('เปลี่ยนรูป', style: GoogleFonts.sarabun(color: Colors.black)),
              ),
              _section('ข้อมูลสินค้า'),
              _field('ชื่อสินค้า', 'เช่น มะม่วงน้ำดอกไม้', nameCtrl),
              categoriesAsync.when(
                data: (cats) => _select('หมวดหมู่', _category, () async {
                  final sel = await showModalBottomSheet<Map<String, dynamic>>(
                    context: context,
                    builder: (ctx) => ListView(
                      children: cats
                          .map((cat) => ListTile(
                                title: Text(cat['name']),
                                onTap: () => Navigator.pop(ctx, cat),
                              ))
                          .toList(),
                    ),
                  );
                  if (sel != null) {
                    setState(() {
                      _category = sel['name'];
                      _categoryId = sel['id'];
                    });
                  }
                }),
                loading: () => _select('หมวดหมู่', 'กำลังโหลด...', () {}),
                error: (_, __) => _select('หมวดหมู่', 'โหลดผิดพลาด', () {}),
              ),
              _field('ราคา', 'เช่น 120', priceCtrl, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], trailingHint: 'บาท'),
              _field('รายละเอียดสินค้า', 'บอกรายละเอียด จุดเด่น วิธีเก็บรักษา ฯลฯ', detailCtrl, maxLines: 6, underline: 1.5),
              _section('สถานที่'),
              _select('จังหวัด', _province, () async {
                final sel = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => const SizedBox(height: 500, child: ProvincePicker()),
                );
                if (sel != null) {
                  setState(() => _province = sel);
                }
              }),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'กรอกข้อมูลให้ครบถ้วนเพื่อช่วยให้ขายได้ไวขึ้น\nเมื่อกด “เผยแพร่” ถือว่ายอมรับเงื่อนไขการลงประกาศ',
                  style: GoogleFonts.sarabun(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveProduct('post'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF062252),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('เผยแพร่', style: GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        color: const Color(0xFFF0F0F0),
        child: Text(t, style: GoogleFonts.sarabun(fontWeight: FontWeight.bold, color: const Color(0xFF062252))),
      );

  Widget _field(
    String l,
    String h,
    TextEditingController c, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? trailingHint,
    double underline = 1.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: underline)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(l, style: GoogleFonts.sarabun(fontSize: 14))),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: c,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      hintText: h,
                      hintStyle: GoogleFonts.sarabun(color: Colors.grey[500]),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    textAlign: TextAlign.right,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'จำเป็นต้องกรอก' : null,
                    style: GoogleFonts.sarabun(),
                  ),
                ),
                if (trailingHint != null) Text(trailingHint, style: GoogleFonts.sarabun(color: Colors.black54))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _select(String l, String? v, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(l, style: GoogleFonts.sarabun(fontSize: 14))),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(v ?? 'เลือก', style: GoogleFonts.sarabun(color: Colors.grey[600])),
                  const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
