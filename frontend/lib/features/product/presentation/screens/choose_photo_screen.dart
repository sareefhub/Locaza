import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChoosePhotoScreen extends StatefulWidget {
  const ChoosePhotoScreen({super.key});

  @override
  State<ChoosePhotoScreen> createState() => _ChoosePhotoScreenState();
}

class _ChoosePhotoScreenState extends State<ChoosePhotoScreen> {
  final List<XFile> _allImages = [];
  final List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _pickImages();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        _allImages.addAll(pickedImages); // เก็บภาพทั้งหมดที่เลือก
      });
    }
  }

// เมื่อผู้ใช้แตะที่ภาพ
  void _onImageTapped(XFile image) {
    setState(() {
      if (_selectedImages.contains(image)) {
        // ถ้าเลือกภาพอยู่แล้ว
        _selectedImages.remove(image); // ลบภาพที่เลือกออก
      } else {
        if (_selectedImages.length < 5) {
          // จำกัดการเลือกสูงสุด 5 ภาพ
          _selectedImages.add(image); // เพิ่มภาพที่เลือก
        }
      }
    });
  }

  int _getSelectionIndex(XFile image) {
    final index = _selectedImages.indexOf(image);
    return index == -1 ? 0 : index + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: const Color(0xFFE0F3F7),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => context.go('/post'),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF062252),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Photo',
                  style: TextStyle(
                    color: Color(0xFF062252),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/arrow-right.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: _selectedImages.isNotEmpty
                        ? () {
                            context.push('/postform',
                                extra:
                                    _selectedImages); // ส่งภาพที่เลือกไปยัง PostFormScreen
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: _allImages.length, // ใช้ _allImages แทน
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final image =
                      _allImages[index]; // ใช้ _allImages แทน _selectedImages
                  final selectionIndex = _getSelectionIndex(image);

                  return GestureDetector(
                    onTap: () => _onImageTapped(image),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (selectionIndex > 0)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF062252),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$selectionIndex',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              'Select photo that are real products,\nwithout any photo editing.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
