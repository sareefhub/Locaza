import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseCard extends StatelessWidget {
  final String seller;
  final String productName;
  final String time;
  final String price;
  final String status;
  final String imageUrl;

  const PurchaseCard({
    super.key,
    required this.seller,
    required this.productName,
    required this.time,
    required this.price,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ร้านและสถานะ
              Row(
                children: [
                  const Icon(Icons.store, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      seller,
                      style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: GoogleFonts.sarabun(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // รูปสินค้า, ชื่อ, เวลา, ราคา
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปสินค้า
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(imageUrl, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.image, size: 30, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  // ชื่อสินค้า + เวลา
                  SizedBox(
                    height: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: GoogleFonts.sarabun(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          time,
                          style: GoogleFonts.sarabun(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // ราคา
                  SizedBox(
                    height: 70,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        price,
                        style: GoogleFonts.sarabun(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
