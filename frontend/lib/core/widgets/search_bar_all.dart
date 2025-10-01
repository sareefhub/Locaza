import 'package:flutter/material.dart';
import 'custom_search_bar.dart';
import 'package:go_router/go_router.dart';

class SearchBarAll extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;

  const SearchBarAll({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () {
              context.go('/home');
            },
            icon: Image.asset(
              'assets/icons/angle-small-left.png',
              width: 24,
              height: 24,
            ),
          ),

          // Search field (ใช้ CustomSearchBar)
          Expanded(
            child: CustomSearchBar(
              hintText: 'ค้นหาสินค้า',
              controller: searchController,
              onChanged: onSearchChanged,
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
        ],
      ),
    );
  }
}
