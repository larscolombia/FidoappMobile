import 'package:intl/intl.dart';

class TimezoneUtils {
  // Zona horaria de República Dominicana (UTC-4)
  static const String dominicanTimezone = 'America/Santo_Domingo';
  
  /// Convierte una fecha que viene del servidor (en zona horaria de República Dominicana)
  /// a la zona horaria local del dispositivo
  static DateTime convertFromDominicanToLocal(String? dateString) {
    if (dateString == null || dateString.isEmpty) return DateTime.now();
    
    try {
      // Parsear el formato "dd-MM-yyyy HH:mm" que viene del servidor
      final parts = dateString.split(' ');
      if (parts.length == 2) {
        final datePart = parts[0]; // "dd-MM-yyyy"
        final timePart = parts[1]; // "HH:mm"
        
        final dateParts = datePart.split('-');
        final timeParts = timePart.split(':');
        
        if (dateParts.length == 3 && timeParts.length == 2) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          
          // Crear DateTime en zona horaria de República Dominicana (UTC-4)
          // La fecha viene en formato local de República Dominicana, así que la tratamos como UTC-4
          final dominicanDateTime = DateTime.utc(year, month, day, hour, minute);
          
          // República Dominicana está en UTC-4, así que sumamos 4 horas para obtener UTC real
          final utcDateTime = dominicanDateTime.add(const Duration(hours: 4));
          
          // Convertir a zona horaria local del dispositivo
          final localDateTime = utcDateTime.toLocal();
          
          return localDateTime;
        }
      }
    } catch (e) {
      print('Error converting timezone: $e');
    }
    
    return DateTime.now();
  }
  
  /// Formatea una fecha para mostrar en la UI con la zona horaria local
  static String formatLocalDate(DateTime dateTime, {String format = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(format).format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return '';
    }
  }
  
  /// Formatea una hora para mostrar en la UI con la zona horaria local
  static String formatLocalTime(DateTime dateTime, {String format = 'HH:mm'}) {
    try {
      return DateFormat(format).format(dateTime);
    } catch (e) {
      print('Error formatting time: $e');
      return '';
    }
  }
  
  /// Convierte y formatea una fecha del servidor para mostrar en la UI
  static String formatServerDateToLocal(String? dateString, {String format = 'dd/MM/yyyy'}) {
    final localDateTime = convertFromDominicanToLocal(dateString);
    return formatLocalDate(localDateTime, format: format);
  }
  
  /// Convierte y formatea una hora del servidor para mostrar en la UI
  static String formatServerTimeToLocal(String? dateString, {String format = 'HH:mm'}) {
    final localDateTime = convertFromDominicanToLocal(dateString);
    return formatLocalTime(localDateTime, format: format);
  }
  
  /// Verifica si una fecha es de hoy (en zona horaria local)
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }
  
  /// Verifica si una fecha es de ayer (en zona horaria local)
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
           dateTime.month == yesterday.month &&
           dateTime.day == yesterday.day;
  }
  
  /// Obtiene una fecha del servidor y la convierte a DateTime local
  static DateTime getLocalDateTimeFromServer(String? dateString) {
    return convertFromDominicanToLocal(dateString);
  }
} 