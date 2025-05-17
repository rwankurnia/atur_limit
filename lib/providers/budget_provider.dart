import 'package:atur_limit/models/budget.dart';
import 'package:atur_limit/models/expense.dart';
import 'package:atur_limit/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';

class BudgetProvider extends ChangeNotifier {
  Budget? _budget;
  List<Expense> _expenses = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  Budget? get budget => _budget;
  List<Expense> get expenses => _expenses;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final budgetData = await SharedPrefsHelper.loadBudget();
    final expenseData = await SharedPrefsHelper.loadExpenses();

    final double total = budgetData['totalBudget'];
    final int days = budgetData['totalDays'];

    if (total > 0 && days > 0) {
      _budget = Budget(totalBudget: total, totalDays: days);
    } else {
      _budget = null;
    }

    _expenses = expenseData;
    _isLoading = false;
    notifyListeners();
  }

  void setBudget(double budget, int days) {
    _budget = Budget(totalBudget: budget, totalDays: days);
    SharedPrefsHelper.saveBudget(budget, days);
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    SharedPrefsHelper.saveExpenses(_expenses);
    notifyListeners();
  }

  double get totalSpent =>
      _expenses.fold(0, (sum, item) => sum + item.amount);

  int get daysLeft {
    if (_budget == null) return 0;
    final usedDays = _expenses
        .map((e) => e.date.toIso8601String().split('T')[0])
        .toSet()
        .length;
    return _budget!.totalDays - usedDays;
  }

  double get dailyBudget {
    if (_budget == null) return 0;
    final remaining = _budget!.totalBudget - totalSpent;
    final daysLeftVal = daysLeft;
    return daysLeftVal > 0 ? remaining / daysLeftVal : 0;
  }

  void clearAll() {
    _budget = null;
    _expenses = [];
    SharedPrefsHelper.clearAll();
    notifyListeners();
  }

  void increaseBudget(int amount) {
    if (_budget != null) {
      _budget = Budget(
        totalBudget: _budget!.totalBudget + amount,
        totalDays: _budget!.totalDays,
      );
      SharedPrefsHelper.saveBudget(
        _budget!.totalBudget,
        _budget!.totalDays,
      );
      notifyListeners();
    }
  }

  void saveBudget() {
    if (_budget != null) {
      SharedPrefsHelper.saveBudget(_budget!.totalBudget, _budget!.totalDays);
    }
  }

  void setExpenses(List<Expense> expenses) {
    _expenses = expenses;
    SharedPrefsHelper.saveExpenses(_expenses);
    notifyListeners();
  }
}