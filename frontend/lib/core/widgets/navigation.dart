import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/user_session.dart';
import '../../routing/routes.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      // ปุ่มหน้าแรก
      context.go(AppRoutes.home);
    } else {
      // ตรวจสอบการล็อกอิน
      if (UserSession.id == null) {
        // ยังไม่ได้ล็อกอิน
        context.go(AppRoutes.login);
      } else {
        // ล็อกอินแล้ว ไปหน้าที่ปุ่มกำหนด
        switch (index) {
          case 1:
            context.go(AppRoutes.notification);
            break;
          case 2:
            context.go(AppRoutes.post);
            break;
          case 3:
            context.go(AppRoutes.chat);
            break;
          case 4:
            context.go(AppRoutes.profile);
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(textTheme: GoogleFonts.sarabunTextTheme()),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        backgroundColor: const Color(0xFFE0F3F7),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.sarabun(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: GoogleFonts.sarabun(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png'), size: 20),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/bell.png'), size: 20),
            label: 'การแจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/more.png'), size: 20),
            label: 'โพสต์',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/comment.png'), size: 20),
            label: 'แชท',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/user.png'), size: 20),
            label: 'ฉัน',
          ),
        ],
      ),
    );
  }
}
