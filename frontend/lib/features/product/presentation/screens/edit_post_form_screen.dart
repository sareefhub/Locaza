import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditPostFormScreen extends StatefulWidget {
  final String postId;

  const EditPostFormScreen({super.key, required this.postId});

  @override
  State<EditPostFormScreen> createState() => _EditPostFormScreenState();
}

class _EditPostFormScreenState extends State<EditPostFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String _productName = '', _price = '', _productDetail = '', _phone = '';
  String? _category, _province;
  String _imageUrl = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
    );
    if (picked != null) {
      setState(() {
        _imageUrl = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.sarabun(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        leading: const BackButton(color: Colors.black),
        title: Text('แก้ไขโพสต์', style: titleStyle),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                debugPrint("$_productName $_price $_productDetail $_phone");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Mock: บันทึกการแก้ไขเรียบร้อย")),
                );
                Navigator.pop(context);
              }
            },
            child: Text('บันทึก',
                style: GoogleFonts.sarabun(color: Colors.black)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSectionHeader('ข้อมูลสินค้า'),
              _buildTextField(
                'ชื่อสินค้า',
                'เช่น มะม่วงน้ำดอกไม้',
                onSaved: (val) => _productName = val ?? '',
              ),
              _buildSelectField('หมวดหมู่', _category, () {
                setState(() => _category = "หมวดหมู่ตัวอย่าง");
              }),
              _buildTextField(
                'ราคา',
                'เช่น 120',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => _price = val ?? '',
                trailingHint: 'บาท',
              ),
              _buildTextField(
                'รายละเอียดสินค้า',
                'บอกรายละเอียด จุดเด่น วิธีเก็บรักษา ฯลฯ',
                maxLines: 6,
                onSaved: (val) => _productDetail = val ?? '',
              ),
              _buildSectionHeader('รูปภาพ'),
              _buildImagePicker(),
              _buildSectionHeader('สถานที่'),
              _buildSelectField('จังหวัด', _province, () {
                setState(() => _province = "สงขลา");
              }),
              _buildSectionHeader('ติดต่อ'),
              _buildTextField(
                'เบอร์โทร',
                'เช่น 0812345678',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => _phone = val ?? '',
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Mock: เผยแพร่โพสต์เรียบร้อย")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0F3F7),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('เผยแพร่',
                        style: GoogleFonts.sarabun(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final border = Border.all(color: const Color(0xFF062252));
    final radius = BorderRadius.circular(12);

    ImageProvider? provider;
    if (_imageUrl.isNotEmpty) {
      if (_imageUrl.startsWith('http')) {
        provider = NetworkImage(_imageUrl);
      } else if (_imageUrl.startsWith('assets/')) {
        provider = AssetImage(_imageUrl);
      } else if (File(_imageUrl).existsSync()) {
        provider = FileImage(File(_imageUrl));
      }
    }

    return InkWell(
      onTap: _pickImage,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: border,
          borderRadius: radius,
          image: provider != null
              ? DecorationImage(image: provider, fit: BoxFit.cover)
              : null,
        ),
        child: provider == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: Colors.grey, size: 40),
                  const SizedBox(height: 8),
                  Text('แตะเพื่อเลือกรูป',
                      style: GoogleFonts.sarabun(color: Colors.grey[700])),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('เปลี่ยนรูป',
                          style: GoogleFonts.sarabun(color: Colors.white)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFFF0F0F0),
        child: Text(
          title,
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF062252),
          ),
        ),
      );

  Widget _buildTextField(
    String label,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? trailingHint,
    required FormFieldSetter<String> onSaved,
  }) {
    final labelStyle = GoogleFonts.sarabun(fontSize: 14);
    final inputStyle = GoogleFonts.sarabun();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: Text(label, style: labelStyle)),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle:
                          inputStyle.copyWith(color: Colors.grey[500]),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: TextAlign.right,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'จำเป็นต้องกรอก' : null,
                    onSaved: onSaved,
                    style: inputStyle,
                  ),
                ),
                if (trailingHint != null) ...[
                  const SizedBox(width: 6),
                  Text(trailingHint,
                      style: GoogleFonts.sarabun(color: Colors.black54)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectField(String label, String? value, VoidCallback onTap) {
    final labelStyle = GoogleFonts.sarabun(fontSize: 14);

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
            Expanded(flex: 3, child: Text(label, style: labelStyle)),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(value ?? 'เลือก',
                      style: GoogleFonts.sarabun(
                          fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right,
                      size: 18, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
