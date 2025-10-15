import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// imports intentionally minimal; model usage done via StorageService
import '../services/storage_service.dart';
import '../services/cycle_calculator.dart';
import 'log_symptoms_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  // entries and user loaded as part of initialization (not stored as fields currently)

  // sets for coloring
  final Set<DateTime> _periodDays = {};
  final Set<DateTime> _fertileDays = {};
  final Set<DateTime> _ovulationDays = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);
    final user = storage.getUser();
    final entries = storage.getEntries();

    // local variables 'user' and 'entries' used below

    // determine last period date: use latest entry with flow != 'none'
    DateTime lastPeriod = DateTime.now().subtract(const Duration(days: 10));
    try {
      final periodEntries = entries.where((e) => e.flow != 'none').toList();
      if (periodEntries.isNotEmpty) {
        periodEntries.sort((a, b) => a.date.compareTo(b.date));
        lastPeriod = periodEntries.last.date;
      }
    } catch (_) {}

    final cycleLength = user?.settings.cycleLength ?? 28;
    final periodLength = user?.settings.periodLength ?? 5;

    // compute predicted period starts across a range
    final firstCalendarDay = DateTime(_focused.year, _focused.month - 1, 1);
    final lastCalendarDay = DateTime(_focused.year, _focused.month + 1, 31);

    DateTime start = lastPeriod;
    // move start backwards until before firstCalendarDay
    while (start.isAfter(firstCalendarDay)) {
      start = start.subtract(Duration(days: cycleLength));
    }
    // move forward and mark days
    while (start.isBefore(lastCalendarDay.add(const Duration(days: 1)))) {
      // period days
      for (int i = 0; i < periodLength; i++) {
        _periodDays.add(DateTime(start.year, start.month, start.day + i));
      }

      // fertility window
      final window = CycleCalculator.fertilityWindow(start, cycleLength);
      final startFertile = window['start']!;
      final ov = window['ovulation']!;
      final endFertile = window['end']!;

      DateTime d = startFertile;
      while (!d.isAfter(endFertile)) {
        _fertileDays.add(DateTime(d.year, d.month, d.day));
        d = d.add(const Duration(days: 1));
      }
      _ovulationDays.add(DateTime(ov.year, ov.month, ov.day));

      start = start.add(Duration(days: cycleLength));
    }

    setState(() {});
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقويم'),
          backgroundColor: const Color(0xFFFF6B9A),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focused,
                selectedDayPredicate: (day) =>
                    _selected != null && _isSameDay(_selected!, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selected = selectedDay;
                    _focused = focusedDay;
                  });

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: LogSymptomsScreen(),
                    ),
                  );
                },
                calendarFormat: CalendarFormat.month,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final dateKey = DateTime(day.year, day.month, day.day);
                    Color? bg;
                    if (_periodDays.contains(dateKey)) {
                      bg = const Color(0xFFFFC9D3); // pastel pink for period
                    } else if (_ovulationDays.contains(dateKey)) {
                      bg = const Color(0xFFEDE6F7); // lavender for ovulation
                    } else if (_fertileDays.contains(dateKey)) {
                      bg = const Color(0xFFFFF1F3); // light for fertile
                    }

                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _legendItem(const Color(0xFFFFC9D3), 'الطمث'),
                  _legendItem(const Color(0xFFEDE6F7), 'الإباضة'),
                  _legendItem(const Color(0xFFFFF1F3), 'نافذة الخصوبة'),
                ],
              ),
              const SizedBox(height: 12),
              const Text('اضغطي على أي يوم لتسجيل الأعراض أو تحريرها'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
