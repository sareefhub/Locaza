import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../application/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  ButtonStyle buttonStyle({Color? bg, Color? fg, BorderSide? border}) =>
      ElevatedButton.styleFrom(
        backgroundColor: bg ?? Colors.white,
        foregroundColor: fg ?? Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: border ?? BorderSide.none,
        ),
      );

  Widget buildInputField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.sarabun(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        style: GoogleFonts.sarabun(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProviderNotifier);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'สมัครสมาชิก',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sarabun(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF001A72),
                          ),
                        ),
                        const SizedBox(height: 30),
                        buildInputField(
                          hint: "ชื่อผู้ใช้",
                          controller: usernameController,
                        ),
                        buildInputField(
                          hint: "รหัสผ่าน",
                          controller: passwordController,
                          obscure: true,
                        ),
                        buildInputField(
                          hint: "อีเมล",
                          controller: emailController,
                          type: TextInputType.emailAddress,
                        ),
                        buildInputField(
                          hint: "เบอร์โทรศัพท์",
                          controller: phoneController,
                          type: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () async {
                                    final success = await ref
                                        .read(authProviderNotifier.notifier)
                                        .register(
                                          usernameController.text,
                                          passwordController.text,
                                          emailController.text,
                                          phoneController.text,
                                        );
                                    if (success && mounted) {
                                      context.go('/home');
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'สมัครสมาชิกไม่สำเร็จ',
                                            style: GoogleFonts.sarabun(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            style: buttonStyle(
                              bg: const Color(0xFFD0E7F9),
                              fg: Colors.black,
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'สมัครสมาชิก',
                                    style: GoogleFonts.sarabun(fontSize: 16),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'หรือ',
                                style: GoogleFonts.sarabun(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: buttonStyle(
                            bg: Colors.white,
                            fg: Colors.black,
                            border: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          icon: Image.asset(
                            'assets/icons/search.png',
                            height: 24,
                          ),
                          label: Text(
                            "สมัครด้วย Google",
                            style: GoogleFonts.sarabun(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push('/login');
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'มีบัญชีอยู่แล้ว? ',
                              style: GoogleFonts.sarabun(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: 'เข้าสู่ระบบ',
                                  style: GoogleFonts.sarabun(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Center(
                            child: Image.asset('assets/logo.png', height: 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
