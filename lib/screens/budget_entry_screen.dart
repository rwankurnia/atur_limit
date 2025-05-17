import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../utils/export_import_helper.dart';
import '../models/budget.dart';
import '../models/expense.dart';

class BudgetEntryScreen extends StatefulWidget {
  const BudgetEntryScreen({super.key});

  @override
  State<BudgetEntryScreen> createState() => _BudgetEntryScreenState();
}

class _BudgetEntryScreenState extends State<BudgetEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _daysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atur Anggaran')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Masukkan Total Anggaran dan Total Hari',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),// jarak diperkecil
            SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Total Anggaran (Rp)',
                            labelStyle: GoogleFonts.poppins( // Tambahkan gaya font di sini
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                            prefixIcon: const Icon(Icons.attach_money_outlined),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Input total anggaran' : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _daysController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Total Hari',
                            labelStyle: GoogleFonts.poppins( // Tambahkan gaya font di sini
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Input total hari' : null,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final budget = double.parse(_budgetController.text);
                                final days = int.parse(_daysController.text);
                                Provider.of<BudgetProvider>(context, listen: false).setBudget(budget, days);
                              }
                            },
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () async {
                  final data = await ExportImportHelper.importBudgetAndExpenses();
                  if (!mounted) return;
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
                child: const Text('Import Data Tersimpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
