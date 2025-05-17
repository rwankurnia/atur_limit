import 'package:atur_limit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../utils/export_import_helper.dart';
import '../models/budget.dart';
import '../models/expense.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.delete_forever, color: Colors.red[400]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Data', style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      minimumSize: const Size.fromHeight(40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Reset Data'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text('Apakah kamu yakin ingin menghapus semua data? Tindakan ini tidak dapat dibatalkan.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<BudgetProvider>(context, listen: false).clearAll();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ya, Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.color_lens),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Tampilan', style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.brightness_6),
                    label: const Text('Ganti Tema'),
                    onPressed: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.import_export),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Ekspor & Impor', style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Export'),
                          onPressed: () async {
                            final provider = Provider.of<BudgetProvider>(context, listen: false);
                            final budget = provider.budget;
                            final expenses = provider.expenses;
                            if (budget == null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tidak ada data anggaran untuk diexport')),
                              );
                              return;
                            }
                            final path = await ExportImportHelper.exportBudgetAndExpenses(budget, expenses);
                            if (!context.mounted) return;
                            if (path != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Data berhasil diexport ke $path')),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.download),
                          label: const Text('Import'),
                          onPressed: () async {
                            final data = await ExportImportHelper.importBudgetAndExpenses();
                            if (!context.mounted) return;
                            if (data != null) {
                              final budgetData = data['budget'];
                              final expensesData = data['expenses'] as List<dynamic>;
                              if (budgetData != null) {
                                final budget = Budget(
                                  totalBudget: (budgetData['totalBudget'] as num).toDouble(),
                                  totalDays: budgetData['totalDays'] as int,
                                  startDate: budgetData['startDate'] != null
                                      ? DateTime.tryParse(budgetData['startDate'])
                                      : null,
                                );
                                final expenses = expensesData.map((e) => Expense(
                                  description: e['description'],
                                  amount: (e['amount'] as num).toDouble(),
                                  date: DateTime.parse(e['date']),
                                )).toList();
                                if (!context.mounted) return;
                                final provider = Provider.of<BudgetProvider>(context, listen: false);
                                provider.setBudget(budget.totalBudget, budget.totalDays);
                                provider.setExpenses(expenses);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Data berhasil diimport!')),
                                );
                              }
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Import dibatalkan atau file tidak valid')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

