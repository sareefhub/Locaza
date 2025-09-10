import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // ปุ่ม style
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

  // ปุ่มที่มี icon
  Widget buildButton(String label, String asset, VoidCallback onTap) =>
      ElevatedButton.icon(
        onPressed: onTap,
        style: buttonStyle(
          bg: Colors.white,
          fg: Colors.black,
          border: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        icon: Image.asset(asset, height: 24),
        label: Text(label, style: const TextStyle(fontSize: 16)),
      );

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 20),
                        const Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001A72),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // กล่องกรอกเบอร์โทร
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1.5),
                          ),
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // ปุ่ม Sign Up
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // ตอนนี้ยังไม่ทำฟังก์ชัน
                            },
                            style: buttonStyle(
                                bg: const Color(0xFFD0E7F9),
                                fg: Colors.black),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // เส้นคั่น
                        const Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    thickness: 1.5, color: Colors.grey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 1.5, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // ปุ่มสมัครด้วย Google (แค่ UI)
                        buildButton('Continue with Google',
                            'assets/icons/search.png', () {
                          // ยังไม่ทำฟังก์ชัน
                        }),
                        const SizedBox(height: 16),
                        // ลิงก์ไปหน้า Login
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push('/login');
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Have an account? ',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 16),
                              children: const [
                                TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // โลโก้ด้านล่าง
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Center(
                              child: Image.asset('assets/logo.png', height: 40)),
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
