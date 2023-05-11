import 'dart:convert';

/// Mapped PageCodec
abstract class MappedPageCodec extends Encoding {
  final MappedPageEncoder _encoder;
  final MappedPageDecoder _decoder;

  /// Mapped PageCodec
  const MappedPageCodec(this._encoder, this._decoder) : super();

  @override
  MappedPageEncoder get encoder => _encoder;

  @override
  MappedPageDecoder get decoder => _decoder;
}

/// Mapped PageEncoder
class MappedPageEncoder extends Converter<String, List<int>> {
  /// coder map
  final Map<int, int> coderMap;

  /// Mapped PageEncoder
  const MappedPageEncoder(this.coderMap);

  @override
  List<int> convert(String input) {
    List<int> bits = [];
    for (var i in input.codeUnits) {
      if (i < 0x80) {
        bits.add(i);
      } else {
        int code = coderMap[i] ?? 0;
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

/// Mapped PageDecoder
class MappedPageDecoder extends Converter<List<int>, String> {
  final bool _allowInvalid;

  /// coder map
  final Map<int, int> coderMap;

  /// Mapped PageDecoder
  const MappedPageDecoder(this.coderMap, [this._allowInvalid = false]);

  @override
  String convert(List<int> input) {
    int leadPointer = 0;
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      int pointer = input[i];
      if (leadPointer != 0) {
        if (pointer >= 0x41 && pointer <= 0xfe) {
          //int code = (leadPointer - 0x81) * 190 + (pointer - 0x41);
          int code = leadPointer << 8 + pointer;

          sb.writeCharCode(code < 0x80 ? code : (coderMap[code] ?? 0));
        }
        leadPointer = 0;
      } else if (pointer < 0x80) {
        sb.writeCharCode(pointer);
      } else if (pointer >= 0x81 && pointer <= 0xfe) {
        leadPointer = pointer;
      } else {
        if (!_allowInvalid) throw Exception('');
      }
    }
    if (leadPointer != 0) {
      if (!_allowInvalid) throw Exception('');
    }
    return sb.toString();
  }
}
