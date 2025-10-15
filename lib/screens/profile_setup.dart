import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../services/storage_service.dart';
import '../components/rounded_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _cycleCtrl = TextEditingController(text: '28');

  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _cycleCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    final user = User(
      id: const Uuid().v4(),
      name: _nameCtrl.text.isEmpty ? null : _nameCtrl.text,
      locale: 'ar',
      settings: UserSettings(
        cycleLength: int.tryParse(_cycleCtrl.text) ?? 28,
        periodLength: 5,
      ),
    );

    await storage.saveUser(user);

    if (!mounted) return;
    setState(() => _saving = false);

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعداد الملف الشخصي'),
          backgroundColor: const Color(0xFFFF6B9A),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الاسم (اختياري)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'العمر (اختياري)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الوزن (اختياري)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cycleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'طول الدورة المتوسط (اليوم)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                RoundedButton(
                  text: _saving ? 'جاري الحفظ...' : 'احفظ وابدأ',
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
