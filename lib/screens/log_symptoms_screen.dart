import 'package:flutter/material.dart';
import '../components/symptom_chip.dart';

class LogSymptomsScreen extends StatefulWidget {
  const LogSymptomsScreen({super.key});

  @override
  State<LogSymptomsScreen> createState() => _LogSymptomsScreenState();
}

class _LogSymptomsScreenState extends State<LogSymptomsScreen> {
  String flow = 'none';
  int pain = 1;
  final Map<String, bool> symptoms = {
    'صداع': false,
    'انتفاخ': false,
    'آلام بطن': false,
    'تعب': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الأعراض'),
        backgroundColor: const Color(0xFFFF6B9A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('شدة النزف'),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('لا'),
                    selected: flow == 'none',
                    onSelected: (v) {
                      setState(() {
                        flow = 'none';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('خفيف'),
                    selected: flow == 'light',
                    onSelected: (v) {
                      setState(() {
                        flow = 'light';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('متوسط'),
                    selected: flow == 'medium',
                    onSelected: (v) {
                      setState(() {
                        flow = 'medium';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('ثقيل'),
                    selected: flow == 'heavy',
                    onSelected: (v) {
                      setState(() {
                        flow = 'heavy';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('الألم (1-10)'),
              Slider(
                value: pain.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: pain.toString(),
                onChanged: (v) {
                  setState(() => pain = v.toInt());
                },
              ),
              const SizedBox(height: 12),
              const Text('الأعراض'),
              Wrap(
                children: symptoms.keys
                    .map(
                      (s) => SymptomChip(
                        label: s,
                        selected: symptoms[s]!,
                        onTap: () {
                          setState(() => symptoms[s] = !(symptoms[s]!));
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B9A),
                ),
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
