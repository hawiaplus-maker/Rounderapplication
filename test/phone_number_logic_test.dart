import 'package:flutter_test/flutter_test.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

void main() {
  test('local mobile accepts both accepted Saudi shapes', () {
    expect(normalizeSaudiLocalMobile('0512345678'), '0512345678');
    expect(normalizeSaudiLocalMobile('512345678'), '0512345678');
    expect(normalizeSaudiLocalMobile('٠٥١٢٣٤٥٦٧٨'), '0512345678');
    expect(normalizeSaudiLocalMobile('051234567'), isNull);
  });

  test('entry mirror grows only into the accepted local shapes', () {
    expect(saudiLocalMobileAllows(''), isTrue);
    expect(saudiLocalMobileAllows('0512345678'), isTrue);
    expect(saudiLocalMobileAllows('05123456789'), isFalse);
    expect(saudiLocalMobileAllows('512345678'), isTrue);
    expect(saudiLocalMobileAllows('5123456789'), isFalse);
    expect(saudiLocalMobileAllows('4'), isFalse);
  });

  test('international numbers normalize Arabic and Urdu digits', () {
    expect(normalizePhoneDigits('+٩٦٦ (٥٠) ۱۲۳-۴۵۶۷'), '+966501234567');
    expect(isIntlPhone('+966501234567'), isTrue);
    expect(isIntlPhone('0501234567'), isFalse);
  });

  test('digitsOnly strips formatting', () {
    expect(digitsOnly('05 123-4567'), '051234567');
  });
}
