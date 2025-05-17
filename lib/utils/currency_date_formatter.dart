import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(amount);
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy', 'id_ID').format(date);
}