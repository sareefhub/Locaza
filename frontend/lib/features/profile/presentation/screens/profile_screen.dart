import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/navigation.dart';
import '../../../../utils/user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? userId;
  String? phone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      username = UserSession.username ?? "Mock User";
      userId = UserSession.id ?? "U123456789";
      phone = UserSession.phone ?? "0812345678";
      isLoading = false;
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("ยืนยันการออกจากระบบ"),
        content: const Text("คุณแน่ใจหรือไม่ที่จะออกจากระบบ?"),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              UserSession.clear();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD1E9F2),
              foregroundColor: Colors.black,
            ),
            child: const Text("ยืนยัน"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          backgroundImage: UserSession.avatarUrl != null
                              ? NetworkImage(UserSession.avatarUrl!)
                              : const AssetImage('assets/icons/user.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ผู้ใช้',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                username!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'หมายเลขผู้ใช้: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: userId,
                                      style: const TextStyle(
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
                          label: const Text(
                            'แก้ไขโปรไฟล์',
                            overflow: TextOverflow.ellipsis,
                          ),
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
                          title: const Text("ประวัติการซื้อ"),
                          onTap: () {
                            context.go('/purchase_history');
                          },
                        ),
                        ListTile(
                          leading: const ImageIcon(
                            AssetImage('assets/icons/seller.png'),
                            size: 20,
                          ),
                          title: const Text("ร้านค้าของฉัน"),
                          onTap: () {
                            final sellerData = {
                              'id': UserSession.id ?? '1',
                              'name': UserSession.username ?? 'ร้านค้าของฉัน',
                              'avatar_url': UserSession.avatarUrl ?? '',
                              'rating': 4.9,
                              'followers': 120,
                              'products': [],
                              'categories': [],
                            };

                            context.push(
                              '/store/${UserSession.id ?? '1'}',
                              extra: {'isOwner': true, 'seller': sellerData},
                            );
                          },
                        ),
                        ListTile(
                          leading: const ImageIcon(
                            AssetImage('assets/icons/heart.png'),
                            size: 20,
                          ),
                          title: const Text("รายการโปรด"),
                          onTap: () {
                            context.go('/favorite');
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _confirmLogout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1E9F2),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              child: Text('Log Out'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
