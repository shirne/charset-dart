import 'dart:convert';
import 'dart:math';
import 'shift_jis_table.dart';

/// ShiftJis Decoder
class ShiftJISDecoder extends Converter<List<int>, String> {
  final bool _allowMalformed;

  /// ShiftJis Decoder
  const ShiftJISDecoder({bool allowMalformed = false})
      : _allowMalformed = allowMalformed;
  @override
  convert(input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      final c1 = input[i];
      List<int>? c2;
      if (c1 <= 0x7F) {
        // ASCII Compatible (partially)
        c2 = utfToShiftJisTable[c1];
      } else if (c1 >= 0xa1 && c1 <= 0xdf) {
        // Half-width Hiragana
        c2 = utfToShiftJisTable[c1];
      } else if (c1 >= 0x81 && c1 <= 0x9f) {
        // JIS X 0208
        c2 = utfToShiftJisTable[(c1 << 8) + input[++i]];
      } else if (c1 >= 0xe0 && c1 <= 0xef) {
        // JIS X 0208
        c2 = utfToShiftJisTable[(c1 << 8) + input[++i]];
      } else {
        // Unknown
      }
      if (c2 != null) {
        result.addAll(c2);
      } else if (_allowMalformed) {
        result.add(unicodeReplacementCharacterRune);
      } else {
        throw FormatException('Unfinished Shift-JIS octet sequence', input, i);
      }
    }
    return utf8.decode(result, allowMalformed: _allowMalformed);
  }
}

/// ShiftJis Encoder
class ShiftJISEncoder extends Converter<String, List<int>> {
  /// ShiftJis Encoder
  const ShiftJISEncoder();

  @override
  List<int> convert(String input) {
    List<int> result = [];
    for (int i = 0; i < input.length; i++) {
      var bytes = utf8.encode(input[i]);
      var value = 0;

      for (var i = 0, length = bytes.length; i < length; i++) {
        value += bytes[i] * (pow(256, (bytes.length - i - 1)) as int);
      }

      result.addAll(shiftJisToUtfTable[value] ?? [0xFFFD]);
    }
    return result;
  }
}

/// ShiftJis Codec
class ShiftJISCodec extends Encoding {
  final bool _allowMalformed;

  /// ShiftJis Codec
  const ShiftJISCodec({bool allowMalformed = false})
      : _allowMalformed = allowMalformed;

  @override
  Converter<List<int>, String> get decoder => _allowMalformed
      ? const ShiftJISDecoder(allowMalformed: true)
      : const ShiftJISDecoder(allowMalformed: false);

  @override
  Converter<String, List<int>> get encoder => const ShiftJISEncoder();

  @override
  String get name => 'shift-jis';
}

/// The instance of ShiftJIS Codec
const shiftJis = ShiftJISCodec();
