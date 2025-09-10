import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data ชั่วคราว
    final favorites = [
      {"name": "Product A", "price": "฿199"},
      {"name": "Product B", "price": "฿299"},
      {"name": "Product C", "price": "฿399"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        centerTitle: true,
        title: Text(
          'รายการโปรด',
          style: GoogleFonts.sarabun(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/angle-small-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => context.go('/profile'),
        ),
      ),
      backgroundColor: Colors.white,
      body: favorites.isEmpty
          ? const Center(child: Text('ยังไม่มีรายการโปรด'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: favorites.length,
              itemBuilder: (_, index) {
                final product = favorites[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite, size: 40, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          product["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(product["price"]!),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
