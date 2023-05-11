import 'dart:convert';
import 'euc_kr_table.dart';

/// The instance of EucKRCodec
const eucKr = EucKRCodec(true);

/// EUC-KR Codec
class EucKRCodec extends Encoding {
  final bool _allowInvalid;

  /// EUC-KR Codec
  const EucKRCodec([this._allowInvalid = false]) : super();

  @override
  String get name => "euc-kr";

  @override
  EucKREncoder get encoder => const EucKREncoder();

  @override
  EucKRDecoder get decoder =>
      _allowInvalid ? const EucKRDecoder(true) : const EucKRDecoder();
}

/// EUC-KR Encoder
class EucKREncoder extends Converter<String, List<int>> {
  /// EUC-KR Encoder
  const EucKREncoder();

  @override
  List<int> convert(String input) {
    List<int> bits = [];
    for (var i in input.codeUnits) {
      if (i < 0x80) {
        bits.add(i);
      } else {
        int code = utf8ToEucKr[i] ?? 0;
        if (code > 0) {
          // bits.add(code ~/ 190 + 0x81);
          // bits.add(code % 190 + 0x41);
          bits.add(code >> 8);
          bits.add(code & 0xff);
        }
      }
    }
    return bits;
  }
}

/// EUC-KR Decoder
class EucKRDecoder extends Converter<List<int>, String> {
  final bool _allowInvalid;

  /// EUC-KR Decoder
  const EucKRDecoder([this._allowInvalid = false]);

  @override
  String convert(List<int> input) {
    int leadPointer = 0;
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      int pointer = input[i];
      if (leadPointer != 0) {
        if (pointer >= 0x41 && pointer <= 0xfe) {
          //int code = (leadPointer - 0x81) * 190 + (pointer - 0x41);
          int code = (leadPointer << 8) + pointer;
          final charCode = code < 0x80 ? code : eucKrToUtf8[code];
          if (charCode == null && !_allowInvalid) {
            throw FormatException('Unfinished Euc-KR octet sequence', input, i);
          } else {
            sb.writeCharCode(charCode ?? unicodeReplacementCharacterRune);
          }
        }
        leadPointer = 0;
      } else if (pointer < 0x80) {
        sb.writeCharCode(pointer);
      } else if (pointer >= 0x81 && pointer <= 0xfe) {
        leadPointer = pointer;
      } else {
        if (!_allowInvalid) {
          throw FormatException('Unfinished Euc-KR octet sequence', input, i);
        }
        sb.writeCharCode(unicodeReplacementCharacterRune);
      }
    }
    if (leadPointer != 0) {
      if (!_allowInvalid) {
        throw FormatException(
          'Unfinished Euc-KR octet sequence',
          input,
          leadPointer,
        );
      }
    }
    return sb.toString();
  }
}
