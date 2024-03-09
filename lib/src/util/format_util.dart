import 'package:intl/intl.dart';

class FormatUtil {
  static String stringToMoney(
    String text, {
    bool symbol = false,
  }) {
    var value = double.parse(text);
    final formatter = NumberFormat.simpleCurrency(
      locale: "pt_Br",
      name: !symbol ? '' : null,
    );
    return formatter.format(value);
  }

  static String dateTimeToShortString(DateTime dateTime) {
    var day = dateTime.day.toString().padLeft(2, '0');
    var month = dateTime.month.toString().padLeft(2, '0');
    var year = dateTime.year.toString().padLeft(2, '0');
    return "$day/$month/$year";
  }

  static String dateTimeToLongString(DateTime dateTime) {
    var day = dateTime.day.toString().padLeft(2, '0');
    var year = dateTime.year.toString().padLeft(2, '0');
    var month = DateFormat.MMM("pt_Br").format(dateTime);
    return "$day $month $year";
  }

  static String doubleToMoney(
    double value, {
    bool symbol = false,
  }) {
    final formatter = NumberFormat.simpleCurrency(
      locale: "pt_Br",
      name: !symbol ? '' : null,
    );
    return formatter.format(value);
  }
}
