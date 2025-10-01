import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.sarabun(fontSize: 14, color: Colors.black),
      cursorColor: Colors.grey,
      cursorWidth: 2,
      cursorHeight: 18,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.sarabun(color: Colors.black54, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 226, 226, 226),
            width: 1,
          ), // กำหนดขอบเริ่มต้น
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 226, 226, 226),
            width: 1,
          ), // ขอบก่อนกด
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ), // ขอบตอนกด
        ),
      ),
    );
  }
}
