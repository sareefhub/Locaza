// search_bar_all.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarAll extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;

  const SearchBarAll({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.onSortPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/icons/angle-small-left.png',
              width: 24,
              height: 24,
            ),
          ),

          // Search field
          Expanded(
            child: TextField(
              style: GoogleFonts.sarabun(
                fontSize: 14,
              ),
              controller: searchController,
              onChanged: onSearchChanged,
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

          // Filter button
          GestureDetector(
            onTap: onFilterPressed,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.filter_alt_outlined),
            ),
          ),
          const SizedBox(width: 4),

          // Sort button
          GestureDetector(
            onTap: onSortPressed,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.sort),
            ),
          ),
        ],
      ),
    );
  }
}
