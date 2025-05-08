import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../utils/currency_formatter.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<BudgetProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final e = expenses[index];
          return ListTile(
            title: Text(e.description),
            subtitle: Text(e.date.toIso8601String().split('T')[0]),
            trailing: Text(formatCurrency(e.amount)),
          );
        },
      ),
    );
  }
}