import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(title: const Text('Pengeluaran Harian')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(9),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sisa Anggaran',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  formatter.format(provider.budget!.totalBudget - provider.totalSpent),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sisa Hari',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${provider.daysLeft} hari',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Anggaran Harian',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  formatter.format(provider.dailyBudget),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                const ExpenseForm(),
                const SizedBox(height: 16),
                const SizedBox( // Ganti Expanded dengan SizedBox
                  height: 252, // Atur tinggi tetap untuk daftar pengeluaran
                  child: ExpenseList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: Text(
                  'Tambah Anggaran',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                  ),
              ),
                content: TextField(
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300,
                  ),
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Masukkan jumlah'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
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
                    child: Text(
                      'Tambah',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
