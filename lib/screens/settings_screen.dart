import 'package:atur_limit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Apakah kamu yakin ingin menghapus semua data? Tindakan ini tidak dapat dibatalkan.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<BudgetProvider>(context, listen: false).clearAll();
                          Navigator.of(context).pop(); // Tutup dialog setelah clear
                        },
                        child: const Text('Ya, Hapus'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Reset All Data'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
              child: const Text('Change Theme'),
            ),
          ],
        ),
      ),
    );
  }
}