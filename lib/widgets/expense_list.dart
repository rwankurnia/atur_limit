import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/budget_provider.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    final dateFormat = DateFormat('dd MMM yyyy');

    final expenses = provider.expenses.reversed.toList();

    if (expenses.isEmpty) {
      return const Center(child: Text('Belum ada pengeluaran.'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final e = expenses[index];
        return ListTile(
          title: Text(e.description),
          subtitle: Text(dateFormat.format(e.date)),
          trailing: Text(formatter.format(e.amount)),
        );
      },
    );
  }
}