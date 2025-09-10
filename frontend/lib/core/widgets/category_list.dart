import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/features/product/presentation/screens/category_productlist_screen.dart';

class CategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'หมวดหมู่',
              style: GoogleFonts.sarabun(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  final label = category['label'] ?? 'ไม่ระบุ';
                  final image = category['image'] ?? 'assets/images/placeholder.png';

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductListScreen(
                              categoryName: label,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 60,
                            child: Text(
                              label,
                              style: GoogleFonts.sarabun(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
