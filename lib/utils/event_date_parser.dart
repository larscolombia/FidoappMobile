import 'package:intl/intl.dart';

/// Parses a date + time coming in mixed formats:
/// Supported date formats: yyyy-MM-dd, dd-MM-yyyy, yyyy/MM/dd, dd/MM/yyyy
/// Time expected as H:m or HH:mm. Returns null if invalid.
DateTime? parseEventDateTime(String? rawDate, String? rawTime) {
  if (rawDate == null || rawDate.isEmpty || rawTime == null || rawTime.isEmpty) return null;
  try {
    final cleanedDate = rawDate.trim().replaceAll('/', '-');
    final timeParts = rawTime.split(':');
    if (timeParts.length < 2) return null;
    final hourStr = timeParts[0].padLeft(2, '0');
    final minuteStr = timeParts[1].padLeft(2, '0');

    final patterns = <String>['yyyy-MM-dd', 'dd-MM-yyyy', 'yyyy/MM/dd', 'dd/MM/yyyy'];
    DateTime? dateOnly;
    for (final p in patterns) {
      try {
        dateOnly = DateFormat(p).parseStrict(cleanedDate);
        break;
      } catch (_) {
        continue;
      }
    }
    if (dateOnly == null) return null;
    final hour = int.tryParse(hourStr);
    final minute = int.tryParse(minuteStr);
    if (hour == null || minute == null) return null;
    return DateTime(dateOnly.year, dateOnly.month, dateOnly.day, hour, minute);
  } catch (_) {
    return null;
  }
}
