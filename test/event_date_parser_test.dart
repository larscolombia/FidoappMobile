import 'package:flutter_test/flutter_test.dart';
import 'package:pawlly/utils/event_date_parser.dart';

void main() {
  group('parseEventDateTime', () {
    test('parses yyyy-MM-dd', () {
      final dt = parseEventDateTime('2025-08-14', '5:56');
      expect(dt, isNotNull);
      expect(dt!.year, 2025);
      expect(dt.month, 8);
      expect(dt.day, 14);
      expect(dt.hour, 5);
      expect(dt.minute, 56);
    });

    test('parses dd-MM-yyyy', () {
      final dt = parseEventDateTime('14-08-2025', '05:07');
      expect(dt, isNotNull);
      expect(dt!.day, 14);
      expect(dt.month, 8);
      expect(dt.year, 2025);
      expect(dt.hour, 5);
      expect(dt.minute, 7);
    });

    test('returns null for invalid', () {
      final dt = parseEventDateTime('14-08', '05:07');
      expect(dt, isNull);
    });
  });
}
