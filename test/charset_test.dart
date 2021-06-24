import 'package:charset/charset.dart';
import 'package:test/test.dart';

void main() {
  test('adds one to input values', () {
    expect(
        utf16.decode([254, 255, 78, 10, 85, 132, 130, 229, 108, 52]), '上善若水');

    expect(
        utf16.encode("上善若水"), [254, 255, 78, 10, 85, 132, 130, 229, 108, 52]);
  });
}
