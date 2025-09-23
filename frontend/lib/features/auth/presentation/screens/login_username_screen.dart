import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../infrastructure/services/auth_api.dart';

class LoginUsernameScreen extends StatefulWidget {
  const LoginUsernameScreen({super.key});

  @override
  State<LoginUsernameScreen> createState() => _LoginUsernameScreenState();
}

class _LoginUsernameScreenState extends State<LoginUsernameScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthApi _authApi = AuthApi();

  bool _isLoading = false;

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

    setState(() => _isLoading = true);

    try {
      final token = await _authApi.login(username, password);
      debugPrint("Login success: $token");

      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: "Success",
          desc: "Login successful!",
          btnOkOnPress: () {
            context.go('/home');
          },
        ).show();
      }
    } catch (e) {
      debugPrint("Login failed: $e");

      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: "Login failed: $e",
          btnOkOnPress: () {},
        ).show();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F5F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Log In',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001A72),
              ),
            ),
            const SizedBox(height: 30),
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
                  decoration: const InputDecoration(
                    hintText: 'Username or Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
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
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD0E7F9),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.black)
                    : const Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Image.asset(
                'assets/logo.png',
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
