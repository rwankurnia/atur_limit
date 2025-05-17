import 'package:atur_limit/utils/currency_date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<BudgetProvider>(context).expenses.reversed.toList();

    if (expenses.isEmpty) {
      return const Center(child: Text('Belum ada pengeluaran.'));
    }

    return ListView.separated(
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final e = expenses[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              e.description,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              formatDate(e.date),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatCurrency(e.amount),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 14),
                  tooltip: 'Edit deskripsi',
                  onPressed: () async {
                    final controller = TextEditingController(text: e.description);
                    final newDesc = await showDialog<String>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Edit Deskripsi'),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                          decoration: const InputDecoration(hintText: 'Deskripsi baru'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
                    );
                    if (!context.mounted) return;
                    if (newDesc != null && newDesc.isNotEmpty && newDesc != e.description) {
                      final provider = Provider.of<BudgetProvider>(context, listen: false);
                      final updated = List.of(provider.expenses.reversed.toList());
                      updated[index] = Expense(
                        description: newDesc,
                        amount: e.amount,
                        date: e.date,
                      );
                      provider.setExpenses(updated.reversed.toList());
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deskripsi pengeluaran diperbarui.')),
                      );
                    }
                  },
                ),
              ],
            ),
            onTap: null,
          ),
        );
      },
    );
  }
}