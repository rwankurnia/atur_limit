import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/expense_list.dart';
import '../widgets/expense_form.dart';
import 'package:intl/intl.dart';

class DailyExpenseScreen extends StatelessWidget {
  const DailyExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('Tambah Anggaran'),
                content: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Masukkan jumlah'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      final amount = int.tryParse(controller.text);
                      if (amount != null && amount > 0) {
                        Provider.of<BudgetProvider>(context, listen: false)
                            .increaseBudget(amount);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Tambah'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Pengeluaran Harian')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sisa Anggaran: ${formatter.format(provider.budget!.totalBudget - provider.totalSpent)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sisa Hari: ${provider.daysLeft}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Anggaran Harian: ${formatter.format(provider.dailyBudget)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const ExpenseForm(),
            const SizedBox(height: 16),
            const Expanded(child: ExpenseList()),
          ],
        ),
      ),
    );
  }
}