import 'package:flutter_test/flutter_test.dart';
import 'package:radioaktywne/extensions/extensions.dart';

void main() {
  test("Test 1: removing bunch of trailing `0`'s", () {
    expect('12340000'.removeTrailing('0'), '1234');
  });
  test('Test 2: removing only 1 trailing character', () {
    expect('12340'.removeTrailing('0'), '1234');
  });
  test("Test 3: removing trailing `0`'s from only-`0` string", () {
    expect('00000000'.removeTrailing('0'), '');
  });
  test("Test 4: the provided character isn't in the string", () {
    expect('1234'.removeTrailing('0'), '1234');
  });
  test("Test 5: the provided character isn't trailing", () {
    expect('12304'.removeTrailing('0'), '12304');
  });
}
