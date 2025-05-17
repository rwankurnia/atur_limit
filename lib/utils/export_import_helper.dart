import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/budget.dart';
import '../models/expense.dart';

class ExportImportHelper {
  // Export budget & expenses ke file JSON
  static Future<String?> exportBudgetAndExpenses(Budget budget, List<Expense> expenses) async {
    final data = {
      'budget': {
        'totalBudget': budget.totalBudget,
        'totalDays': budget.totalDays,
        'startDate': budget.startDate?.toIso8601String(),
      },
      'expenses': expenses.map((e) => {
        'description': e.description,
        'amount': e.amount,
        'date': e.date.toIso8601String(),
      }).toList(),
    };
    final jsonString = jsonEncode(data);
    // Simpan ke folder Downloads di macOS
    String? downloadsDir;
    if (Platform.isMacOS) {
      downloadsDir = p.join(Platform.environment['HOME'] ?? '', 'Downloads');
    } else if (Platform.isAndroid) {
      downloadsDir = '/storage/emulated/0/Download';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      downloadsDir = dir.path;
    }
    final file = File(p.join(downloadsDir, 'atur_limit_export.json'));
    await file.writeAsString(jsonString);
    return file.path;
  }

  // Import budget & expenses dari file JSON
  static Future<Map<String, dynamic>?> importBudgetAndExpenses() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);
      return data;
    }
    return null;
  }
}
