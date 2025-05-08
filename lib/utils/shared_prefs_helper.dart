import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class SharedPrefsHelper {
  static const _expensesKey = 'expenses';

  static Future<void> saveBudget(double totalBudget, int totalDays) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalBudget', totalBudget);
    prefs.setInt('totalDays', totalDays);
  }

  static Future<Map<String, dynamic>> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'totalBudget': prefs.getDouble('totalBudget') ?? 0.0,
      'totalDays': prefs.getInt('totalDays') ?? 0
    };
  }

  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expenseList = expenses.map((e) => json.encode({
      'description': e.description,
      'amount': e.amount,
      'date': e.date.toIso8601String(),
    })).toList();
    prefs.setStringList(_expensesKey, expenseList);
  }

  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseList = prefs.getStringList(_expensesKey) ?? [];
    return expenseList.map((e) {
      final data = json.decode(e);
      return Expense(
        description: data['description'],
        amount: data['amount'],
        date: DateTime.parse(data['date']),
      );
    }).toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}