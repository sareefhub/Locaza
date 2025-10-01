import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../application/auth_provider.dart';
import '../../../../routing/routes.dart';

class LoginUsernameScreen extends ConsumerStatefulWidget {
  const LoginUsernameScreen({super.key});

  @override
  ConsumerState<LoginUsernameScreen> createState() =>
      _LoginUsernameScreenState();
}

class _LoginUsernameScreenState extends ConsumerState<LoginUsernameScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return;

    final success = await ref
        .read(authProviderNotifier.notifier)
        .login(username, password);

    if (!mounted) return;

    if (success) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: "สำเร็จ",
        desc: "เข้าสู่ระบบเรียบร้อยแล้ว!",
        btnOkOnPress: () {
          context.go('/home');
        },
        titleTextStyle: GoogleFonts.sarabun(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        descTextStyle: GoogleFonts.sarabun(fontSize: 16),
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: "เกิดข้อผิดพลาด",
        desc: "เข้าสู่ระบบไม่สำเร็จ",
        btnOkOnPress: () {},
        titleTextStyle: GoogleFonts.sarabun(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        descTextStyle: GoogleFonts.sarabun(fontSize: 16),
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProviderNotifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE6F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Image.asset(
                          'assets/icons/angle-small-left.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.sarabun(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF001A72),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'ชื่อผู้ใช้',
                          hintStyle: GoogleFonts.sarabun(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'รหัสผ่าน',
                          hintStyle: GoogleFonts.sarabun(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                        style: GoogleFonts.sarabun(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD0E7F9),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: Colors.grey.shade300, width: 1.5),
                        ),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            )
                          : Text(
                              'เข้าสู่ระบบ',
                              style: GoogleFonts.sarabun(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Image.asset('assets/logo.png', height: 40),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
