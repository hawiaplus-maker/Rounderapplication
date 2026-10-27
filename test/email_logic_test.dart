import 'package:flutter_test/flutter_test.dart';
import 'package:rounder_application/logic/email_logic.dart';

void main() {
  test('ordinary addresses are accepted', () {
    expect(isEmail('resident@rounder.app'), isTrue);
    expect(isEmail('  resident@rounder.app  '), isTrue);
  });

  test('empty, broken and overlong addresses are rejected', () {
    expect(isEmail(''), isFalse);
    expect(isEmail('resident'), isFalse);
    expect(isEmail('resident@rounder'), isFalse);
    expect(isEmail('${'a' * 250}@rounder.app'), isFalse);
  });
}
