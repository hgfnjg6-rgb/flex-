import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  void _next() {
    if (_controller.page! < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: [
                    _buildPage(
                      title: 'تعقب وتنظيم دورتك الشهرية',
                      body:
                          'تتبعي أعراضك، سجلي المواعيد، واحصلي على تنبؤات دقيقة.',
                      asset: 'assets/mockups/hero.png',
                    ),
                    _buildPage(
                      title: 'كيف نحسب الدورة',
                      body: 'أدخلي طول دورتك ومتوسطها ليتم حساب نافذة الخصوبة.',
                      asset: 'assets/mockups/hero2.png',
                    ),
                    _buildPage(
                      title: 'إشعارات وتذكيرات',
                      body:
                          'اضبطي التذكيرات لتلقي تنبيهات قبل الدورة والإباضة.',
                      asset: 'assets/mockups/hero3.png',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/auth'),
                      child: const Text('تخطي'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B9A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('التالي'),
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

  Widget _buildPage({
    required String title,
    required String body,
    required String asset,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Image.asset(
            asset,
            height: 300,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFF8C8D8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
