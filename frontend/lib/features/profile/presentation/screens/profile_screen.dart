import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/navigation.dart';
import '../../../../utils/user_session.dart';
import '../../../../config/api_config.dart';
import '../../infrastructure/profile_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? userId;
  String? phone;
  String? avatarUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await UserSession.loadFromStorage();

    if (UserSession.token != null) {
      try {
        final profile = await ProfileApi().getProfile();
        if (profile != null) {
          setState(() {
            username = profile['username'] ?? "Guest";
            userId = profile['id']?.toString() ?? "-";
            phone = profile['phone'] ?? "-";
            avatarUrl = profile['avatar_url'];
          });
        } else {
          _setGuest();
        }
      } catch (_) {
        _setGuest();
      }
    } else {
      _setGuest();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => isLoading = false);
  }

  void _setGuest() {
    username = "Guest";
    userId = "-";
    phone = "-";
    avatarUrl = null;
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: GoogleFonts.sarabunTextTheme(),
        ),
        child: AlertDialog(
          title: Text("ยืนยันการออกจากระบบ",
              style: Theme.of(context).textTheme.titleMedium),
          content: Text("คุณแน่ใจหรือไม่ที่จะออกจากระบบ?",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child:
                  Text("ยกเลิก", style: Theme.of(context).textTheme.bodyMedium),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop();
                UserSession.clear();
                _setGuest();
                setState(() {});
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD1E9F2),
                foregroundColor: Colors.black,
              ),
              child:
                  Text("ยืนยัน", style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.sarabunTextTheme(),
      ),
      child: Scaffold(
        bottomNavigationBar: const BottomNavBar(currentIndex: 4),
        backgroundColor: const Color(0xFFE0F3F7),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFFE0F3F7),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: avatarUrl != null
                                ? NetworkImage(ApiConfig.fixUrl(avatarUrl))
                                : const AssetImage('assets/icons/user.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ผู้ใช้',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                ),
                                Text(
                                  username ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    children: [
                                      TextSpan(
                                        text: 'หมายเลขผู้ใช้: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                      TextSpan(
                                        text: userId ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await context.push('/edit_profile');
                              await _loadUserData();
                            },
                            icon: const ImageIcon(
                              AssetImage('assets/icons/edit.png'),
                              size: 16,
                            ),
                            label: Text('แก้ไขโปรไฟล์',
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1E9F2),
                              foregroundColor: Colors.black,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const ImageIcon(
                              AssetImage('assets/icons/seller-store.png'),
                              size: 20,
                            ),
                            title: Text("ประวัติการซื้อ",
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () => context.go('/purchase_history'),
                          ),
                          ListTile(
                            leading: const ImageIcon(
                              AssetImage('assets/icons/seller.png'),
                              size: 20,
                            ),
                            title: Text("ร้านค้าของฉัน",
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () {
                              final sellerData = {
                                'id': userId ?? '1',
                                'name': username ?? 'ร้านค้าของฉัน',
                                'avatar_url': avatarUrl ?? '',
                                'rating': 4.9,
                                'followers': 120,
                                'products': [],
                                'categories': [],
                              };
                              context.push(
                                '/store/${userId ?? '1'}',
                                extra: {'isOwner': true, 'seller': sellerData},
                              );
                            },
                          ),
                          ListTile(
                            leading: const ImageIcon(
                              AssetImage('assets/icons/heart.png'),
                              size: 20,
                            ),
                            title: Text("รายการโปรด",
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () => context.go('/favorite'),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: UserSession.token != null
                                  ? () => _confirmLogout(context)
                                  : () => context.go('/login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD1E9F2),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                                child: Text(
                                  UserSession.token != null
                                      ? 'Log Out'
                                      : 'Log In',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
