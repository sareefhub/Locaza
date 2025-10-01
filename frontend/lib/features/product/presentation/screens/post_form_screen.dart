import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/widgets/province_picker.dart';
import '../../../../utils/user_session.dart';
import '../../application/product_provider.dart';
import '../../application/category_provider.dart';

class PostFormScreen extends ConsumerStatefulWidget {
  final List<XFile>? images;
  const PostFormScreen({super.key, this.images});
  @override
  ConsumerState<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends ConsumerState<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final detailCtrl = TextEditingController();
  String? _category, _province;
  int? _categoryId;

  Future<void> _saveProduct(String state) async {
    if (!_formKey.currentState!.validate()) return;
    List<String> uploaded = [];
    if (widget.images != null) {
      for (final img in widget.images!) {
        final url = await ref.read(productApiProvider).uploadProductImage(File(img.path));
        if (url != null) uploaded.add(url);
      }
    }
    final product = {
      "seller_id": int.parse(UserSession.id ?? "1"),
      "title": nameCtrl.text.trim(),
      "description": detailCtrl.text.trim(),
      "price": double.tryParse(priceCtrl.text.trim()) ?? 0.0,
      "category_id": _categoryId ?? 1,
      "location": _province ?? "",
      "status": state == 'post' ? 'available' : 'draft',
      "image_urls": uploaded
    };
    await ref.read(productApiProvider).createProduct(product);
    final userId = int.tryParse(UserSession.id ?? "0") ?? 0;
    ref.invalidate(productListByUserProvider(userId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state == 'post' ? '✅ เผยแพร่โพสต์เรียบร้อย' : '✅ บันทึกแบบร่างเรียบร้อย', style: GoogleFonts.sarabun())));
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
        title: Text('สร้างโพสต์', style: GoogleFonts.sarabun(fontWeight: FontWeight.w700)),
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
              if (widget.images != null)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.images!.length,
                    itemBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(widget.images![i].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
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
