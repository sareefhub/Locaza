// search_bar_category.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFilterSortBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
  final ValueChanged<String> onSearchChanged;

  const SearchFilterSortBar({
    super.key,
    required this.searchController,
    required this.onFilterPressed,
    required this.onSortPressed,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // ช่องค้นหา
          Expanded(
            child: TextField(
              style: GoogleFonts.sarabun(
                fontSize: 14,
              ),
              controller: searchController, // ควบคุมการแก้ไขข้อความในช่องค้นหา
              onChanged:
                  onSearchChanged, // เรียกฟังก์ชันทุกครั้งที่พิมพ์เปลี่ยนค่า
              decoration: InputDecoration(
                hintText: 'ค้นหาสินค้า',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // ปุ่ม Filter
          GestureDetector(
            onTap: onFilterPressed,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.filter_alt_outlined),
            ),
          ),
          const SizedBox(width: 8),

          // ปุ่ม Sort
          GestureDetector(
            onTap: onSortPressed,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sort),
            ),
          ),
        ],
      ),
    );
  }
}
