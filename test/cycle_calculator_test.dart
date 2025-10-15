import 'package:flutter_test/flutter_test.dart';
import 'package:monacer/services/cycle_calculator.dart';

void main() {
  test('estimate next period', () {
    final last = DateTime(2025, 10, 1);
    final next = CycleCalculator.estimateNextPeriod(last, 28);
    expect(next, DateTime(2025, 10, 29));
  });

  test('fertility window spans expected range', () {
    final last = DateTime(2025, 10, 1);
    final window = CycleCalculator.fertilityWindow(last, 28);
    expect(window['ovulation'], DateTime(2025, 10, 15));
    expect(window['start']!.isBefore(window['ovulation']!), true);
    expect(window['end']!.isAfter(window['ovulation']!), true);
  });
}
