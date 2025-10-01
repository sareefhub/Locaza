import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/provinces.dart';

class ProvincePicker extends StatefulWidget {
  const ProvincePicker({super.key});

  @override
  State<ProvincePicker> createState() => _ProvincePickerState();
}

class _ProvincePickerState extends State<ProvincePicker> {
  final TextEditingController _controller = TextEditingController();
  List<String> filtered = provinces;

  void _onSearchChanged(String value) {
    setState(() {
      filtered = provinces
          .where((p) => p.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "ค้นหาจังหวัด...",
                hintStyle: GoogleFonts.sarabun(),
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: filtered
                  .map((p) => ListTile(
                        title: Text(p, style: GoogleFonts.sarabun()),
                        onTap: () => Navigator.pop(context, p),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}