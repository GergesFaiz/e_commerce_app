import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('egp', () {
    test('groups thousands like the design', () {
      expect(egp(1200), 'EGP 1,200');
      expect(egp(3500.0), 'EGP 3,500');
      expect(egp(149), 'EGP 149');
      expect(egp(1234567), 'EGP 1,234,567');
    });

    test('keeps two decimals for fractional prices', () {
      expect(egp(99.5), 'EGP 99.50');
      expect(egp(1999.99), 'EGP 1,999.99');
    });
  });

  group('ServerFailure.messageFrom', () {
    test('prefers the validation error message', () {
      expect(
        ServerFailure.messageFrom({
          'message': 'fail',
          'errors': {'msg': 'Account Already Exists', 'param': 'email'},
        }),
        'Account Already Exists',
      );
    });

    test('falls back to message', () {
      expect(
        ServerFailure.messageFrom(
            {'statusMsg': 'fail', 'message': 'Incorrect email or password'}),
        'Incorrect email or password',
      );
    });

    test('ignores non-JSON bodies', () {
      expect(ServerFailure.messageFrom('<html>Not Found</html>'), isNull);
      expect(ServerFailure.messageFrom(null), isNull);
    });
  });
}
