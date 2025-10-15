import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);
    final user = storage.getUser();
    if (mounted) setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلوماتي'),
        backgroundColor: const Color(0xFFFF6B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? const Center(child: Text('لم يتم إعداد الملف الشخصي'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الاسم: ${_user!.name}'),
                  const SizedBox(height: 8),
                  Text('طول الدورة: ${_user!.settings.cycleLength} يوم'),
                  const SizedBox(height: 8),
                  Text('مدة الحيض: ${_user!.settings.periodLength} يوم'),
                ],
              ),
      ),
    );
  }
}
