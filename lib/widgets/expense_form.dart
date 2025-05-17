import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/budget_provider.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final desc = _descController.text;
      final amount = double.tryParse(_amountController.text) ?? 0;

      final expense = Expense(
        description: desc,
        amount: amount,
        date: DateTime.now(),
      );

      Provider.of<BudgetProvider>(context, listen: false).addExpense(expense);
      _descController.clear();
      _amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 14),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Jumlah (Rp)',
              labelStyle: GoogleFonts.poppins( // Tambahkan gaya font di sini
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: 'Deskripsi',
              labelStyle: GoogleFonts.poppins( // Tambahkan gaya font di sini
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.description),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Tambah Pengeluaran'),
            ),
          )
        ],
      ),
    );
  }
}