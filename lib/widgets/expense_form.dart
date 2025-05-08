import 'package:flutter/material.dart';
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
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

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
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Deskripsi'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Wajib diisi' : null,
          ),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Tambah Pengeluaran'),
          )
        ],
      ),
    );
  }
}