import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(amount);
}