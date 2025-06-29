// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:intl/intl.dart';
import 'package:pawlly/utils/constants.dart';


// TODO:Cambiar esta extensión por un helper
extension DateTimeExt on DateTime {
  // El formato que se recibe por defecto desde la api
  static const String _apiFormat = DateFormatConst.DD_MM_YYYY;

  String formatToLocale([String format = 'd \'de\' MMMM \'de\' yyyy', String locale = 'es_ES']) {
    final DateFormat formatter = DateFormat(format, locale);
    return formatter.format(this);
  }

  String toStringDMY([String locale = 'es_ES']) {
    final DateFormat formatter = DateFormat(_apiFormat, locale);
    return formatter.format(this);
  }

  static DateTime? parseFromDMY(String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }

    final DateFormat inputFormat = DateFormat(_apiFormat);
    return inputFormat.parse(date);
  }
}
