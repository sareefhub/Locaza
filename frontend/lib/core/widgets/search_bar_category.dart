// search_bar_category.dart
import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/custom_search_bar.dart'; // import CustomSearchBar

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;
  final ValueChanged<String> onSearchChanged;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.onFilterPressed,
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
            child: CustomSearchBar(
              hintText: 'ค้นหาสินค้า',
              controller: searchController,
              onChanged: onSearchChanged,
            ),
          ),
          const SizedBox(width: 8),

          // ปุ่ม Filter
          GestureDetector(
            onTap: onFilterPressed,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.filter_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
