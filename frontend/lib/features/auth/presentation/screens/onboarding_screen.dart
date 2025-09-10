import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Trusted Community',
      'desc':
          'Every user verifies their identity and address to ensure a safe and reliable experience',
      'image': 'assets/onboarding/onboarding-1.png',
    },
    {
      'title': 'Easy Item Listings',
      'desc':
          'Snap a photo, set your price, write details, and choose a category',
      'image': 'assets/onboarding/onboarding-2.png',
    },
    {
      'title': 'Smart Search & Chat',
      'desc':
          'Filter by category, price, or distance and chat with sellers in-app',
      'image': 'assets/onboarding/onboarding-3.png',
    },
    {
      'title': 'Get Started',
      'desc': 'Discover great deals and connect with people near you',
      'image': 'assets/onboarding/onboarding-4.png',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    context.go('/home');
  }

  void _nextPage() {
    if (_currentIndex == pages.length - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildPage(Map<String, String> item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Image.asset(item['image']!, height: 280),
        const SizedBox(height: 36),
        Text(
          item['title']!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF062252),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            item['desc']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF062252)),
          ),
        ),
        const SizedBox(height: 24),
        _buildDots(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC9E1E6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  _currentIndex == pages.length - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(
                    color: Color(0xFF062252),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Image.asset(
            'assets/logo.png',
            height: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentIndex == index ? 20 : 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? const Color(0xFF062252)
                : const Color(0xFFD0D5DD),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F3F7),
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) => _buildPage(pages[index]),
      ),
    );
  }
}
