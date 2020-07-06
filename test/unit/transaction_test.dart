import 'package:bytebank/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the value when create a transaction', () {
    final transaction = Transaction(null, 200, null);
    expect(transaction.value, equals(200));
  });

  test('Should fail when create a transaction with value less than zero', () {
    expect(() => Transaction(null, -100, null), throwsAssertionError);
  });
}
