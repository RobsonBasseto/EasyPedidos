import 'package:intl/intl.dart';

class DateFormatter {
  static String formatarHora(DateTime data) {
    return DateFormat('HH:mm').format(data);
  }

  static String formatarDataHora(DateTime data) {
    return DateFormat('dd/MM/yyyy HH:mm').format(data);
  }
}
