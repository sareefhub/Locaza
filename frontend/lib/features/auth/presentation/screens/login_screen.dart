import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    buttonStyle({Color? bg, Color? fg, BorderSide? border}) =>
        ElevatedButton.styleFrom(
          backgroundColor: bg ?? Colors.white,
          foregroundColor: fg ?? Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ?? BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
        );

    buildIconButton(String label, String asset, VoidCallback onTap) =>
        ElevatedButton.icon(
          onPressed: onTap,
          icon: Image.asset(asset, height: 24),
          label: Text(label, style: GoogleFonts.sarabun(fontSize: 16)),
          style: buttonStyle(),
        );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo-splash.png', height: 120),
                    const SizedBox(height: 48),
                    buildIconButton(
                      'เข้าสู่ระบบด้วย Google',
                      'assets/icons/search.png',
                      () {},
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.grey, height: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'หรือ',
                            style: GoogleFonts.sarabun(color: Colors.grey),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.grey, height: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          GoRouter.of(context).push('/loginusername'),
                      style: buttonStyle(bg: Colors.blue.shade100),
                      child: Text(
                        "เข้าสู่ระบบด้วยชื่อผู้ใช้",
                        style: GoogleFonts.sarabun(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ยังไม่มีบัญชี? ", style: GoogleFonts.sarabun()),
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push('/signup'),
                          child: Text(
                            "สมัครสมาชิก",
                            style: GoogleFonts.sarabun(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Material(
                color: Colors.white, // สีพื้นหลัง
                shape: const CircleBorder(),
                elevation: 4, // เงา
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => GoRouter.of(context).push('/home'),
                  child: const Padding(
                    padding: EdgeInsets.all(4), // ขนาดวงกลม
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black, // สีไอคอน
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
