import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final productDetailController = TextEditingController();
  final phoneController = TextEditingController();

  String? _category, _province;

  void _selectCategory() {
    setState(() => _category = "หมวดหมู่ตัวอย่าง");
  }

  void _selectProvince() {
    setState(() => _province = "สงขลา");
  }

  void _saveProduct({String state = 'draft'}) {
    if (!_formKey.currentState!.validate()) return;

    final name = productNameController.text.trim();
    final price = priceController.text.trim();
    final detail = productDetailController.text.trim();
    final phone = phoneController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state == 'post'
              ? '✅ Mock: เผยแพร่โพสต์เรียบร้อย'
              : '✅ Mock: บันทึกแบบร่างเรียบร้อย',
          style: GoogleFonts.sarabun(),
        ),
      ),
    );
    Navigator.pop(context);
    debugPrint("Name: $name, Price: $price, Detail: $detail, Phone: $phone");
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    productDetailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headline = GoogleFonts.sarabun(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        leading: const BackButton(color: Colors.black),
        title: Text('สร้างโพสต์', style: headline),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveProduct(state: 'draft');
              }
            },
            child: Text('บันทึกแบบร่าง',
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
                controller: productNameController,
              ),
              _buildSelectField('หมวดหมู่', _category, _selectCategory),
              _buildTextField(
                'ราคา',
                'เช่น 120',
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                trailingHint: 'บาท',
              ),
              _buildTextField(
                'รายละเอียดสินค้า',
                'บอกรายละเอียด จุดเด่น วิธีเก็บรักษา ฯลฯ',
                controller: productDetailController,
                maxLines: 6,
                underlineThickness: 1.5,
              ),
              _buildSectionHeader('สถานที่'),
              _buildSelectField('จังหวัด', _province, _selectProvince),
              _buildSectionHeader('ติดต่อ'),
              _buildTextField(
                'เบอร์โทร',
                'เช่น 0812345678',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'กรอกข้อมูลให้ครบถ้วนเพื่อช่วยให้ขายได้ไวขึ้น\nเมื่อกด “เผยแพร่” ถือว่ายอมรับเงื่อนไขการลงประกาศ',
                  style: GoogleFonts.sarabun(
                      fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveProduct(state: 'post');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0F3F7),
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF062252)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('เผยแพร่',
                        style: GoogleFonts.sarabun(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
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
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? trailingHint,
    double underlineThickness = 1.0,
  }) {
    final labelStyle = GoogleFonts.sarabun(fontSize: 14);
    final inputStyle = GoogleFonts.sarabun();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey.shade300, width: underlineThickness),
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
                    controller: controller,
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
                    style: inputStyle,
                  ),
                ),
                if (trailingHint != null) ...[
                  const SizedBox(width: 6),
                  Text(trailingHint,
                      style:
                          GoogleFonts.sarabun(color: Colors.black54)),
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
