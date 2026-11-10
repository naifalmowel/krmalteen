import 'package:flutter_test/flutter_test.dart';
import 'package:krm_alten/core/utils/validators.dart';

void main() {
  group('AppValidators Validation Rules', () {
    test('validateName accepts valid names and rejects empty or short input', () {
      expect(AppValidators.validateName(''), isNotNull);
      expect(AppValidators.validateName('علي'), equals(null));
      expect(AppValidators.validateName('محمد عبدالله'), equals(null));
    });

    test('validatePhone accepts Syrian phone numbers and valid length', () {
      expect(AppValidators.validatePhone(''), isNotNull);
      expect(AppValidators.validatePhone('123'), isNotNull);
      expect(AppValidators.validatePhone('0997144071'), equals(null));
      expect(AppValidators.validatePhone('+963997144071'), equals(null));
    });

    test('validateGuests validates positive integer count', () {
      expect(AppValidators.validateGuests('0'), isNotNull);
      expect(AppValidators.validateGuests('-2'), isNotNull);
      expect(AppValidators.validateGuests('4'), equals(null));
      expect(AppValidators.validateGuests('150'), isNotNull); // > 100 asks to call directly
    });
  });
}
