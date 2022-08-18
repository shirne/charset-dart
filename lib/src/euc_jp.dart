import 'dart:convert';
import 'dart:math';
import 'euc_jp_table.dart';

const eucJp = EucJPCodec();

class EucJPDecoder extends Converter<List<int>, String> {
  final bool _allowMalformed;
  const EucJPDecoder([this._allowMalformed = false]);
  @override
  convert(input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      final c1 = input[i];
      final List<int>? codes;
      if (c1 <= 0x7E) {
        // ASCII Compatible
        codes = EUC_TABLE[c1];
      } else if (c1 == 0x8e) {
        // Hiragana
        final c2 = input[++i];
        codes = EUC_TABLE[(c1 << 8) + c2];
      } else if (c1 == 0x8f) {
        // JIS X 0212
        final c2 = input[++i];
        final c3 = input[++i];
        codes = EUC_TABLE[(c1 << 16) + (c2 << 8) + c3];
      } else {
        // JIS X 0208
        final c2 = input[++i];
        codes = EUC_TABLE[(c1 << 8) + c2];
      }
      if (codes == null) {
        if (_allowMalformed) {
          throw FormatException('Unfinished Euc-JP octet sequence', input, i);
        }
        result.add(unicodeReplacementCharacterRune);
      } else {
        result.addAll(codes);
      }
    }
    return utf8.decode(result);
  }
}

class EucJPEncoder extends Converter<String, List<int>> {
  const EucJPEncoder();
  @override
  List<int> convert(String input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      var bytes = utf8.encode(input[i]);
      var value = 0;

      for (var i = 0, length = bytes.length; i < length; i++) {
        value += bytes[i] * (pow(256, (bytes.length - i - 1)) as int);
      }

      result.addAll(UTF_TABLE[value] ?? []);
    }
    return result;
  }
}

class EucJPCodec extends Encoding {
  final bool _allowMalformed;
  const EucJPCodec([this._allowMalformed = false]);

  @override
  Converter<List<int>, String> get decoder =>
      _allowMalformed ? const EucJPDecoder(true) : const EucJPDecoder();

  @override
  Converter<String, List<int>> get encoder => const EucJPEncoder();

  @override
  String get name => 'euc-jp';
}
