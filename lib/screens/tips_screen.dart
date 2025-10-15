import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'اشربي ماء كافياً كل يوم',
      'مارسي تمارين خفيفة لتخفيف الآلام',
      'حاولي تنظيم النوم لتخفيف التوتر',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('نصائح'),
        backgroundColor: const Color(0xFFFF6B9A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tips.length,
        itemBuilder: (context, i) {
          return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(tips[i]),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: (i * 100).ms)
              .moveY(begin: 20);
        },
      ),
    );
  }
}
