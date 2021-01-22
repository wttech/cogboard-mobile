import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Variable should be incremented', () {
    var counter = 1;
    counter++;
    expect(2, counter);
  });
}
