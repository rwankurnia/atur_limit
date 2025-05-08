import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

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
      appBar: AppBar(title: const Text('Set Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Budget (Rp)'),
                validator: (value) => value == null || value.isEmpty ? 'Enter total budget' : null,
              ),
              TextFormField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Days'),
                validator: (value) => value == null || value.isEmpty ? 'Enter total days' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final budget = double.parse(_budgetController.text);
                    final days = int.parse(_daysController.text);
                    Provider.of<BudgetProvider>(context, listen: false).setBudget(budget, days);
                  }
                },
                child: const Text('Save Budget'),
              )
            ],
          ),
        ),
      ),
    );
  }
}