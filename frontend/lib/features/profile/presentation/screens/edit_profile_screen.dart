import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/user_session.dart';
import '../../../../config/api_config.dart';
import '../../application/profile_provider.dart';
import '../../infrastructure/profile_api.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(profileProviderNotifier.notifier).loadProfile();
      final user = ref.read(profileProviderNotifier).user;
      if (user != null) {
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
        _phoneController.text = user['phone'] ?? '';
        _locationController.text = user['location'] ?? '';
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      String? avatarUrl = UserSession.avatarUrl;
      if (_selectedImage != null) {
        avatarUrl = await ProfileApi().uploadAvatar(_selectedImage!);
      }

      await ref.read(profileProviderNotifier.notifier).updateProfile(
            userId: UserSession.id!,
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            avatarUrl: avatarUrl ?? '',
            location: _locationController.text,
          );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Update profile error: $e");
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProviderNotifier);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F3F7),
        title: const Text(
          'แก้ไขโปรไฟล์',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/angle-small-left.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (UserSession.avatarUrl != null
                              ? NetworkImage(ApiConfig.fixUrl(UserSession.avatarUrl))
                              : const AssetImage('assets/icons/circle-user.png'))
                              as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'ชื่อ'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'อีเมล'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'ที่อยู่'),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9E1E6),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      side: const BorderSide(
                        color: Color(0xFF062252),
                        width: 1,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('บันทึกการแก้ไข'),
                  ),
                ],
              ),
            ),
    );
  }
}
