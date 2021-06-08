import 'dart:convert';
import 'dart:math';
import 'euc_jp_table.dart';

const eucJp = const EucJP();

class EucJPDecoder extends Converter<List<int>, String> {
  const EucJPDecoder();
  @override
  convert(input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      var c1 = input[i];
      if (c1 <= 0x7E) {
        // ASCII Compatible
        result.addAll(EUC_TABLE[c1] ?? []);
      } else if (c1 == 0x8e) {
        // Hiragana
        var c2 = input[++i];
        result.addAll(EUC_TABLE[(c1 << 8) + c2] ?? []);
      } else if (c1 == 0x8f) {
        // JIS X 0212
        var c2 = input[++i];
        var c3 = input[++i];
        result.addAll(EUC_TABLE[(c1 << 16) + (c2 << 8) + c3] ?? []);
      } else {
        // JIS X 0208
        var c2 = input[++i];
        result.addAll(EUC_TABLE[(c1 << 8) + c2] ?? []);
      }
    }
    return utf8.decode(result);
  }
}

class EucJPEncoder extends Converter<String, List<int>> {
  const EucJPEncoder();
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

class EucJP extends Encoding {
  const EucJP();

  @override
  Converter<List<int>, String> get decoder => const EucJPDecoder();

  @override
  Converter<String, List<int>> get encoder => const EucJPEncoder();

  @override
  String get name => 'euc-jp';
}
