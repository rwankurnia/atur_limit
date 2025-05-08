import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import 'budget_entry_screen.dart';
import 'daily_expense_screen.dart';
import 'summary_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        if (mounted) {
          Provider.of<BudgetProvider>(context, listen: false).loadData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> pages = [
      provider.budget == null
          ? const BudgetEntryScreen()
          : const DailyExpenseScreen(),
      const SummaryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aplikasi Limit Pengeluaran',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}