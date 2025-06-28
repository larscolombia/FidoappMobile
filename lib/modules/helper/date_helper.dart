import 'package:intl/intl.dart';

class DateHelper {
  // Reemplazar por un valor global configurable
  static String locale = 'es_ES';

  static String dateShortForUi = 'dd-MM-yyyy';

  static String dateShortForApi = 'yyyy-MM-dd';

  static DateTime firstDate = DateTime(1900);
  
  static DateTime lastDate = DateTime(2100, 12, 31);

  static DateTime lastBirthDate = DateTime.now();

  static DateTime? dateFromUiShortString(String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }

    try {
      // Definir el formato de entrada
      DateFormat inputFormat = DateFormat(dateShortForUi, locale);

      // Analizar la fecha de entrada
      DateTime parsedDate = inputFormat.parse(date);

      return parsedDate;
    } catch (e) {
      print("Error al analizar la fecha: $e");
      return null; // Retornar null si la fecha es inválida
    }
  }

  static String formatUiDateShort(DateTime? date) {
    if (date == null) return "Fecha no disponible";

    try {
      // Definir el formato de salida
      DateFormat outputFormat = DateFormat(dateShortForUi, locale);

      // Formatear la fecha al formato deseado
      return outputFormat.format(date);
    } catch (e) {
      return "Fecha inválida";
    }
  }

  static String formatUiDateLong(DateTime? date) {
    if (date == null) return "Fecha no disponible";

    try {
      // Definir el formato de salida
      DateFormat outputFormat = DateFormat(dateShortForApi, locale);

      // Formatear la fecha al formato deseado
      return outputFormat.format(date);
    } catch (e) {
      return "Fecha inválida";
    }
  }

  static String formatUiDateLongFromString(String? date) {
    if (date == null || date.isEmpty) return "Fecha no disponible";

    try {
      // Definir el formato de entrada según el formato de la fecha proporcionada
      DateFormat inputFormat = DateFormat(dateShortForUi);

      // Analizar la fecha de entrada
      DateTime parsedDate = inputFormat.parse(date);

      // Definir el formato de salida
      DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' yyyy", 'es_ES');

      // Formatear la fecha al formato deseado
      String formattedDate = outputFormat.format(parsedDate);

      return formattedDate;
    } catch (e) {
      return "Fecha inválida";
    }
  }
}
