class Budget {
  final double totalBudget;
  final int totalDays;
  final DateTime? startDate;

  Budget({
    required this.totalBudget,
    required this.totalDays,
    this.startDate, // tambahkan parameter opsional
  });
}