import 'package:intl/intl.dart';

class Utils {
  static String getTodayDateFormatted() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static String threeLetterDateFormatted(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(parsedDate);
  }
}
