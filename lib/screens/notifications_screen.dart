import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();

  @override
  void initState() {
    super.initState();
    _service.init();
  }

  Future<void> _scheduleDemo() async {
    final now = DateTime.now().add(const Duration(seconds: 5));
    await _service.scheduleDaily(
      id: 10,
      title: 'تذكير',
      body: 'تذكير تجريبي',
      time: now,
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم جدولة تذكير تجريبي')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التنبيهات'),
        backgroundColor: const Color(0xFFFF6B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('إدارة التذكيرات'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _scheduleDemo,
              child: const Text('جدولة تذكير تجريبي بعد 5 ثواني'),
            ),
          ],
        ),
      ),
    );
  }
}
