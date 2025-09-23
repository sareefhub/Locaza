import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
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

  Widget buildInputField(
      {required String hint,
      required TextEditingController controller,
      bool obscure = false,
      TextInputType type = TextInputType.text}) {
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
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

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
                        buildInputField(
                            hint: "Username", controller: usernameController),
                        buildInputField(
                            hint: "Password",
                            controller: passwordController,
                            obscure: true),
                        buildInputField(
                            hint: "Email",
                            controller: emailController,
                            type: TextInputType.emailAddress),
                        buildInputField(
                            hint: "Phone",
                            controller: phoneController,
                            type: TextInputType.phone),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // UI เท่านั้น ยังไม่เชื่อม API
                            },
                            style: buttonStyle(
                                bg: const Color(0xFFD0E7F9),
                                fg: Colors.black),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: buttonStyle(
                            bg: Colors.white,
                            fg: Colors.black,
                            border:
                                BorderSide(color: Colors.grey.shade300, width: 1.5),
                          ),
                          icon: Image.asset('assets/icons/search.png', height: 24),
                          label: const Text("Continue with Google",
                              style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 16),
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
