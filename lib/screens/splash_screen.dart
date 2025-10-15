import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Alignment> _alignAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _alignAnim = AlignmentTween(
      begin: Alignment(0, -0.2),
      end: Alignment(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    // start entrance animation after small delay
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);
    final user = storage.getUser();
    final next = user == null ? '/profile_setup' : '/main';
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3E8FF), Color(0xFFF8F8FF)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnim.value,
                          child: Align(
                            alignment: _alignAnim.value,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'MonaCare',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6E2A8A),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          // Animated logo via Lottie (simple loop) – fallback to built-in animated container
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: Lottie.asset(
                              'assets/lotties/loading.json',
                              fit: BoxFit.contain,
                              repeat: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 42),
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: ElevatedButton(
                        onPressed: _goNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9B59B6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 42,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ابدأ',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
