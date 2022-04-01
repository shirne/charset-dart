import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'constants.dart';

import 'list_range.dart';
import 'utils.dart';

class Utf32Codec extends Encoding {
  const Utf32Codec();

  @override
  Converter<List<int>, String> get decoder => const Utf32Decoder();

  @override
  Converter<String, List<int>> get encoder => const Utf32Encoder();

  @override
  String get name => 'utf-32';
}

class Utf32Encoder extends Converter<String, List<int>> {
  const Utf32Encoder();

  /// Produce a list of UTF-32 encoded bytes. This method prefixes the resulting
  /// bytes with a big-endian byte-order-marker.
  @override
  Uint8List convert(String input) => encodeUtf32Be(input, true);

  /// Produce a list of UTF-32BE encoded bytes. By default, this method produces
  /// UTF-32BE bytes with no BOM.
  Uint8List encodeUtf32Be(String str, [bool writeBOM = false]) {
    var utf32CodeUnits = stringToCodepoints(str);
    var encoding = Uint8List(4 * utf32CodeUnits.length + (writeBOM ? 4 : 0));
    var i = 0;
    if (writeBOM) {
      encoding[i++] = 0;
      encoding[i++] = 0;
      encoding[i++] = unicodeUtfBomHi;
      encoding[i++] = unicodeUtfBomLo;
    }
    for (var unit in utf32CodeUnits) {
      encoding[i++] = (unit! >> 24) & unicodeByteZeroMask;
      encoding[i++] = (unit >> 16) & unicodeByteZeroMask;
      encoding[i++] = (unit >> 8) & unicodeByteZeroMask;
      encoding[i++] = unit & unicodeByteZeroMask;
    }
    return encoding;
  }

  /// Produce a list of UTF-32LE encoded bytes. By default, this method produces
  /// UTF-32BE bytes with no BOM.
  List<int?> encodeUtf32Le(String str, [bool writeBOM = false]) {
    var utf32CodeUnits = stringToCodepoints(str);
    var encoding = <int?>[]..length =
        4 * utf32CodeUnits.length + (writeBOM ? 4 : 0);
    var i = 0;
    if (writeBOM) {
      encoding[i++] = unicodeUtfBomLo;
      encoding[i++] = unicodeUtfBomHi;
      encoding[i++] = 0;
      encoding[i++] = 0;
    }
    for (var unit in utf32CodeUnits) {
      encoding[i++] = unit! & unicodeByteZeroMask;
      encoding[i++] = (unit >> 8) & unicodeByteZeroMask;
      encoding[i++] = (unit >> 16) & unicodeByteZeroMask;
      encoding[i++] = (unit >> 24) & unicodeByteZeroMask;
    }
    return encoding;
  }
}

class Utf32Decoder extends Converter<List<int>, String> {
  const Utf32Decoder();

  @override
  String convert(List<int> input,
      [int start = 0,
      int? end,
      int replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
    return String.fromCharCodes((Utf32BytesDecoder(input, start,
            end == null ? input.length : end - start, replacementCodepoint))
        .decodeRest()
        .whereType<int>());
  }

  /// Produce a String from a sequence of UTF-32BE encoded bytes. The parameters
  /// allow an offset into a list of bytes (as int), limiting the length of the
  /// values be decoded and the ability of override the default Unicode
  /// replacement character. Set the replacementCharacter to null to throw an
  /// ArgumentError rather than replace the bad value.
  String decodeUtf32Be(List<int> bytes,
          [int offset = 0,
          int? length,
          bool stripBom = true,
          int replacementCodepoint = unicodeReplacementCharacterCodepoint]) =>
      String.fromCharCodes((Utf32beBytesDecoder(
              bytes, offset, length, stripBom, replacementCodepoint))
          .decodeRest()
          .whereType<int>());

  /// Produce a String from a sequence of UTF-32LE encoded bytes. The parameters
  /// allow an offset into a list of bytes (as int), limiting the length of the
  /// values be decoded and the ability of override the default Unicode
  /// replacement character. Set the replacementCharacter to null to throw an
  /// ArgumentError rather than replace the bad value.
  String decodeUtf32Le(List<int> bytes,
          [int offset = 0,
          int? length,
          bool stripBom = true,
          int replacementCodepoint = unicodeReplacementCharacterCodepoint]) =>
      String.fromCharCodes((Utf32leBytesDecoder(
              bytes, offset, length, stripBom, replacementCodepoint))
          .decodeRest()
          .whereType<int>());
}

const Utf32Codec utf32 = Utf32Codec();

/// Identifies whether a List of bytes starts (based on offset) with a
/// byte-order marker (BOM).
bool hasUtf32Bom(List<int> utf32EncodedBytes, [int offset = 0, int? length]) {
  return hasUtf32beBom(utf32EncodedBytes, offset, length) ||
      hasUtf32leBom(utf32EncodedBytes, offset, length);
}

/// Identifies whether a List of bytes starts (based on offset) with a
/// big-endian byte-order marker (BOM).
bool hasUtf32beBom(List<int> utf32EncodedBytes, [int offset = 0, int? length]) {
  var end = length != null ? offset + length : utf32EncodedBytes.length;
  return (offset + 4) <= end &&
      utf32EncodedBytes[offset] == 0 &&
      utf32EncodedBytes[offset + 1] == 0 &&
      utf32EncodedBytes[offset + 2] == unicodeUtfBomHi &&
      utf32EncodedBytes[offset + 3] == unicodeUtfBomLo;
}

/// Identifies whether a List of bytes starts (based on offset) with a
/// little-endian byte-order marker (BOM).
bool hasUtf32leBom(List<int> utf32EncodedBytes, [int offset = 0, int? length]) {
  var end = length != null ? offset + length : utf32EncodedBytes.length;
  return (offset + 4) <= end &&
      utf32EncodedBytes[offset] == unicodeUtfBomLo &&
      utf32EncodedBytes[offset + 1] == unicodeUtfBomHi &&
      utf32EncodedBytes[offset + 2] == 0 &&
      utf32EncodedBytes[offset + 3] == 0;
}

typedef Utf32BytesDecoderProvider = Utf32BytesDecoder Function();

/// Return type of [decodeUtf32AsIterable] and variants. The Iterable type
/// provides an iterator on demand and the iterator will only translate bytes
/// as requested by the user of the iterator. (Note: results are not cached.)
// TODO(floitsch): Consider removing the extend and switch to implements since
// that's cheaper to allocate.
class IterableUtf32Decoder extends IterableBase<int?> {
  final Utf32BytesDecoderProvider codeunitsProvider;

  IterableUtf32Decoder._(this.codeunitsProvider);

  @override
  Utf32BytesDecoder get iterator => codeunitsProvider();
}

/// Abstract parent class converts encoded bytes to codepoints.
abstract class Utf32BytesDecoder implements ListRangeIterator {
  // TODO(kevmoo): should this field be private?
  final ListRangeIterator utf32EncodedBytesIterator;
  final int? replacementCodepoint;
  int? _current;

  Utf32BytesDecoder._fromListRangeIterator(
      this.utf32EncodedBytesIterator, this.replacementCodepoint);

  factory Utf32BytesDecoder(List<int> utf32EncodedBytes,
      [int offset = 0,
      int? length,
      int replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
    length ??= utf32EncodedBytes.length - offset;
    if (hasUtf32beBom(utf32EncodedBytes, offset, length)) {
      return Utf32beBytesDecoder(utf32EncodedBytes, offset + 4, length - 4,
          false, replacementCodepoint);
    } else if (hasUtf32leBom(utf32EncodedBytes, offset, length)) {
      return Utf32leBytesDecoder(utf32EncodedBytes, offset + 4, length - 4,
          false, replacementCodepoint);
    } else {
      return Utf32beBytesDecoder(
          utf32EncodedBytes, offset, length, false, replacementCodepoint);
    }
  }

  List<int?> decodeRest() {
    var codeunits = <int?>[]..length = remaining;
    var i = 0;
    while (moveNext()) {
      codeunits[i++] = current;
    }
    return codeunits;
  }

  @override
  int? get current => _current;

  @override
  bool moveNext() {
    _current = null;
    var remaining = utf32EncodedBytesIterator.remaining;
    if (remaining == 0) {
      _current = null;
      return false;
    }
    if (remaining < 4) {
      utf32EncodedBytesIterator.skip(utf32EncodedBytesIterator.remaining);
      if (replacementCodepoint != null) {
        _current = replacementCodepoint;
        return true;
      } else {
        throw ArgumentError(
            'Invalid UTF32 at ${utf32EncodedBytesIterator.position}');
      }
    }
    var codepoint = decode();
    if (_validCodepoint(codepoint)) {
      _current = codepoint;
      return true;
    } else if (replacementCodepoint != null) {
      _current = replacementCodepoint;
      return true;
    } else {
      throw ArgumentError(
          'Invalid UTF32 at ${utf32EncodedBytesIterator.position}');
    }
  }

  @override
  int get position => utf32EncodedBytesIterator.position ~/ 4;

  @override
  void backup([int? by = 1]) {
    utf32EncodedBytesIterator.backup(4 * by!);
  }

  @override
  int get remaining => (utf32EncodedBytesIterator.remaining + 3) ~/ 4;

  @override
  void skip([int? count = 1]) {
    utf32EncodedBytesIterator.skip(4 * count!);
  }

  int decode();
}

/// Convert UTF-32BE encoded bytes to codepoints by grouping 4 bytes
/// to produce the unicode codepoint.
class Utf32beBytesDecoder extends Utf32BytesDecoder {
  Utf32beBytesDecoder(List<int> utf32EncodedBytes,
      [int offset = 0,
      int? length,
      bool stripBom = true,
      int replacementCodepoint = unicodeReplacementCharacterCodepoint])
      : super._fromListRangeIterator(
            (ListRange(utf32EncodedBytes, offset, length)).iterator,
            replacementCodepoint) {
    if (stripBom && hasUtf32beBom(utf32EncodedBytes, offset, length)) {
      skip();
    }
  }

  @override
  int decode() {
    utf32EncodedBytesIterator.moveNext();
    var value = utf32EncodedBytesIterator.current!;
    utf32EncodedBytesIterator.moveNext();
    value = (value << 8) + utf32EncodedBytesIterator.current!;
    utf32EncodedBytesIterator.moveNext();
    value = (value << 8) + utf32EncodedBytesIterator.current!;
    utf32EncodedBytesIterator.moveNext();
    value = (value << 8) + utf32EncodedBytesIterator.current!;
    return value;
  }
}

/// Convert UTF-32BE encoded bytes to codepoints by grouping 4 bytes
/// to produce the unicode codepoint.
class Utf32leBytesDecoder extends Utf32BytesDecoder {
  Utf32leBytesDecoder(List<int> utf32EncodedBytes,
      [int offset = 0,
      int? length,
      bool stripBom = true,
      int replacementCodepoint = unicodeReplacementCharacterCodepoint])
      : super._fromListRangeIterator(
            (ListRange(utf32EncodedBytes, offset, length)).iterator,
            replacementCodepoint) {
    if (stripBom && hasUtf32leBom(utf32EncodedBytes, offset, length)) {
      skip();
    }
  }

  @override
  int decode() {
    utf32EncodedBytesIterator.moveNext();
    var value = utf32EncodedBytesIterator.current!;
    utf32EncodedBytesIterator.moveNext();
    value += (utf32EncodedBytesIterator.current! << 8);
    utf32EncodedBytesIterator.moveNext();
    value += (utf32EncodedBytesIterator.current! << 16);
    utf32EncodedBytesIterator.moveNext();
    value += (utf32EncodedBytesIterator.current! << 24);
    return value;
  }
}

bool _validCodepoint(int codepoint) {
  return (codepoint >= 0 && codepoint < unicodeUtf16ReservedLo) ||
      (codepoint > unicodeUtf16ReservedHi && codepoint < unicodeValidRangeMax);
}
