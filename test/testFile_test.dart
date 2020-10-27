import 'package:flutter_test/flutter_test.dart';
import 'screens/closet_page_tests.dart';

void main() {
  test('Dummy Test', () {
    int i = 0;
    i++;
    expect(i, 1);
  });

  group('Closet', closet_page_tests);

  group('Item Dashboard', () {

  });
}