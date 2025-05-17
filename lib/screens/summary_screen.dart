import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../utils/currency_date_formatter.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _showNewestFirst = true;

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<BudgetProvider>(context).expenses;
    final dateFormat = DateFormat('dd MMM yyyy');
    final displayExpenses = _showNewestFirst
        ? expenses.reversed.toList()
        : expenses.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    const Icon(Icons.summarize, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Pengeluaran', style: GoogleFonts.poppins(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            formatCurrency(expenses.fold(0.0, (a, b) => a + b.amount)),
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Urutan: ', style: GoogleFonts.poppins(fontSize: 14)),
                ToggleButtons(
                  isSelected: [_showNewestFirst, !_showNewestFirst],
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.blueAccent,
                  constraints: const BoxConstraints(minWidth: 80, minHeight: 36),
                  onPressed: (idx) {
                    setState(() {
                      _showNewestFirst = idx == 0;
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Terbaru'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Terlama'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: displayExpenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 56, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text(
                            'Belum ada pengeluaran',
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: displayExpenses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final e = displayExpenses[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            leading: const Icon(Icons.receipt_long, size: 27),
                            title: Text(
                              e.description,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                dateFormat.format(e.date),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            trailing: Text(
                              formatCurrency(e.amount),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}