import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/filter_components.dart'; // ใช้ชื่อจริงจาก pubspec.yaml

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCategory;
  String? selectedProvince;
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  final List<String> categories = ["อาหารสด", "งานหัตถกรรม", "แม่และเด็ก", "เครื่องมือช่าง"];
  final List<String> provinces = ["กรุงเทพฯ", "เชียงใหม่", "สงขลา", "ลำปาง"];

  void _applyFilters() {
    Navigator.pop(context, {
      "category": selectedCategory ?? "",
      "province": selectedProvince ?? "",
      "minPrice": minPriceController.text,
      "maxPrice": maxPriceController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        title: Text("กรองสินค้า", style: GoogleFonts.sarabun(fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              value: selectedCategory,
              items: categories,
              label: "หมวดหมู่",
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              value: selectedProvince,
              items: provinces,
              label: "จังหวัด",
              onChanged: (val) => setState(() => selectedProvince = val),
            ),
            const SizedBox(height: 16),
            PriceRangeInput(
              minPriceController: minPriceController,
              maxPriceController: maxPriceController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("ยืนยัน", style: GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
