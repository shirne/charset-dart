import 'dart:convert';
import 'dart:math';
import 'shift_jis_table.dart';

class ShiftJISDecoder extends Converter<List<int>, String> {
  const ShiftJISDecoder();
  @override
  convert(input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      var c1 = input[i];
      if (c1 <= 0x7F) {
        // ASCII Compatible (partially)
        result.addAll(JIS_TABLE[c1] ?? []);
      } else if (c1 >= 0xa1 && c1 <= 0xdf) {
        // Half-width Hiragana
        result.addAll(JIS_TABLE[c1] ?? []);
      } else if (c1 >= 0x81 && c1 <= 0x9f) {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(JIS_TABLE[(c1 << 8) + c2] ?? []);
      } else if (c1 >= 0xe0 && c1 <= 0xef) {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(JIS_TABLE[(c1 << 8) + c2] ?? []);
      } else {
        // Unknown
        result.addAll([]);
      }
    }
    return utf8.decode(result);
  }
}

class ShiftJISEncoder extends Converter<String, List<int>> {
  const ShiftJISEncoder();
  @override
  List<int> convert(String s) {
    List<int> result = [];
    for (int i = 0; i < s.length; i++) {
      var bytes = utf8.encode(s[i]);
      var value = 0;

      for (var i = 0, length = bytes.length; i < length; i++) {
        value += bytes[i] * (pow(256, (bytes.length - i - 1)) as int);
      }

      result.addAll(UTF_TABLE[value] ?? []);
    }
    return result;
  }
}

class ShiftJIS extends Encoding {
  const ShiftJIS();

  @override
  Converter<List<int>, String> get decoder => const ShiftJISDecoder();

  @override
  Converter<String, List<int>> get encoder => const ShiftJISEncoder();

  @override
  String get name => 'shift-jis';
}

const ShiftJIS shiftJis = const ShiftJIS();
