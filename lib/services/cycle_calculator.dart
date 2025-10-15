class CycleCalculator {
  // Simple logic: given lastPeriodDate and average cycle length, estimate next period start
  static DateTime estimateNextPeriod(
    DateTime lastPeriodStart,
    int cycleLength,
  ) {
    return lastPeriodStart.add(Duration(days: cycleLength));
  }

  // Fertility window: typically ovulation ~14 days before next period
  // fertile window ~ ovulation +/- 5 days
  static Map<String, DateTime> fertilityWindow(
    DateTime lastPeriodStart,
    int cycleLength,
  ) {
    final next = estimateNextPeriod(lastPeriodStart, cycleLength);
    final ovulation = next.subtract(const Duration(days: 14));
    final startFertile = ovulation.subtract(const Duration(days: 5));
    final endFertile = ovulation.add(const Duration(days: 1));
    return {'start': startFertile, 'ovulation': ovulation, 'end': endFertile};
  }
}
