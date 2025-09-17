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
      userId = UserSession.userId ?? "U123456789";
      phone = UserSession.phone ?? "0812345678";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = username != null && userId != null && phone != null;

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
                          backgroundImage: UserSession.profileImageUrl != null
                              ? NetworkImage(UserSession.profileImageUrl!)
                              : const AssetImage('assets/icons/user.png')
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              username ?? 'Guest',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userId != null ? 'User ID\n$userId' : '',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await context.push('/edit_profile');
                            await _loadUserData();
                          },
                          icon: const ImageIcon(
                            AssetImage('assets/icons/edit.png'),
                            size: 16,
                          ),
                          label: const Text('Edit Profile'),
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
                          title: const Text("Purchase History"),
                          onTap: () {
                            context.go('/purchase_history');
                          },
                        ),

                        ListTile(
                          leading: const ImageIcon(
                            AssetImage('assets/icons/seller.png'),
                            size: 20,
                          ),
                          title: const Text("My Store"),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const ImageIcon(
                            AssetImage('assets/icons/heart.png'),
                            size: 20,
                          ),
                          title: const Text("My favorites"),
                          onTap: () {
                            context.go('/favorite');
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLoggedIn) {
                                UserSession.clear();
                                context.go('/login');
                              } else {
                                context.go('/login');
                              }
                            },
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
                              child: Text(isLoggedIn ? 'Log Out' : 'Log In'),
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
