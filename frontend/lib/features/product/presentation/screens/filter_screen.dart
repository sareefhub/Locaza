import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/filter_components.dart';
import 'package:frontend/features/product/application/category_provider.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const FilterScreen({super.key, this.initialFilters});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  int? selectedCategoryId;
  String? selectedLocation;
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  final List<String> locations = [
    "กรุงเทพมหานคร",
    "เชียงใหม่",
    "สงขลา",
    "ลำปาง",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      selectedCategoryId = widget.initialFilters!['category_id'] as int?;
      final loc = widget.initialFilters!['location']?.toString() ?? '';
      selectedLocation = locations.contains(loc) ? loc : null;
      minPriceController.text = widget.initialFilters!['minPrice'] ?? '';
      maxPriceController.text = widget.initialFilters!['maxPrice'] ?? '';
    }
  }

  void _applyFilters() {
    Navigator.pop(context, {
      "category_id": selectedCategoryId,
      "location": selectedLocation ?? "",
      "minPrice": minPriceController.text,
      "maxPrice": maxPriceController.text,
    });
  }

  void _clearFilters() {
    setState(() {
      selectedCategoryId = null;
      selectedLocation = null;
      minPriceController.clear();
      maxPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF315EB2);

    final categoryState = ref.watch(categoryListProvider);
    final categories = categoryState.maybeWhen(
      data: (data) => data,
      orElse: () => <Map<String, dynamic>>[],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/angle-small-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "กรองสินค้า",
          style: GoogleFonts.sarabun(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              value: selectedCategoryId != null
                  ? categories.firstWhere(
                      (c) => c['id'] == selectedCategoryId,
                      orElse: () => {'name': ''},
                    )['name'] as String
                  : null,
              items: categories.map((c) => c['name'] as String).toList(),
              label: "หมวดหมู่",
              onChanged: (val) {
                final selected = categories.firstWhere(
                  (c) => c['name'] == val,
                  orElse: () => {},
                );
                setState(() {
                  selectedCategoryId = selected['id'] as int?;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              value: selectedLocation,
              items: locations,
              label: "จังหวัด",
              onChanged: (val) => setState(() => selectedLocation = val),
            ),
            const SizedBox(height: 16),
            PriceRangeInput(
              minPriceController: minPriceController,
              maxPriceController: maxPriceController,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: mainColor, width: 2),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "ล้างค่า",
                      style: GoogleFonts.sarabun(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "ยืนยัน",
                      style: GoogleFonts.sarabun(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
