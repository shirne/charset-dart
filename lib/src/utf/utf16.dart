import 'dart:convert';
import 'dart:typed_data';

import 'constants.dart';

import 'list_range.dart';
import 'utils.dart';

class Utf16Codec extends Encoding {
  const Utf16Codec();

  @override
  Converter<List<int>, String> get decoder => const Utf16Decoder();

  @override
  Converter<String, List<int>> get encoder => const Utf16Encoder();

  @override
  String get name => 'utf-16';
}

class Utf16Encoder extends Converter<String, List<int>> {
  const Utf16Encoder();

  @override
  List<int> convert(String input) => encodeUtf16Be(input, true);

  Uint8List encodeUtf16Be(String str, [bool writeBOM = false]) {
    var utf16CodeUnits = codepointsToUtf16CodeUnits(str.codeUnits);
    var encoding = Uint8List(2 * utf16CodeUnits.length + (writeBOM ? 2 : 0));
    var i = 0;
    if (writeBOM) {
      encoding[i++] = unicodeUtfBomHi;
      encoding[i++] = unicodeUtfBomLo;
    }
    for (var unit in utf16CodeUnits) {
      encoding[i++] = (unit & unicodeByteOneMask) >> 8;
      encoding[i++] = unit & unicodeByteZeroMask;
    }
    return encoding;
  }

  Uint8List encodeUtf16Le(String str, [bool writeBOM = false]) {
    var utf16CodeUnits = codepointsToUtf16CodeUnits(str.codeUnits);
    var encoding = Uint8List(2 * utf16CodeUnits.length + (writeBOM ? 2 : 0));
    var i = 0;
    if (writeBOM) {
      encoding[i++] = unicodeUtfBomLo;
      encoding[i++] = unicodeUtfBomHi;
    }
    for (var unit in utf16CodeUnits) {
      encoding[i++] = unit & unicodeByteZeroMask;
      encoding[i++] = (unit & unicodeByteOneMask) >> 8;
    }
    return encoding;
  }
}

class Utf16Decoder extends Converter<List<int>, String> {
  const Utf16Decoder();

  /// Produce a String from a sequence of UTF-16 encoded bytes. This method always
  /// strips a leading BOM. Set the [replacementCodepoint] to null to throw  an
  /// ArgumentError rather than replace the bad value. The default
  /// value for the [replacementCodepoint] is U+FFFD.
  @override
  String convert(
    List<int> input, [
    int start = 0,
    int? end,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint,
  ]) {
    var codeunits = (Utf16BytesToCodeUnitsDecoder(input, start,
            end == null ? input.length : end - start, replacementCodepoint))
        .decodeRest();
    return String.fromCharCodes(
        utf16CodeUnitsToCodepoints(codeunits, 0, null, replacementCodepoint)
            .whereType<int>());
  }

  /// Produce a String from a sequence of UTF-16BE encoded bytes. This method
  /// strips a leading BOM by default, but can be overridden by setting the
  /// optional parameter [stripBom] to false. Set the [replacementCodepoint] to
  /// null to throw an ArgumentError rather than replace the bad value.
  /// The default value for the [replacementCodepoint] is U+FFFD.
  String decodeUtf16Be(
    List<int> input, [
    int start = 0,
    int? end,
    bool stripBom = true,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint,
  ]) {
    var codeunits = Utf16beBytesToCodeUnitsDecoder(
      input,
      start,
      end == null ? input.length : end - start,
      stripBom,
      replacementCodepoint,
    ).decodeRest();
    return String.fromCharCodes(
        utf16CodeUnitsToCodepoints(codeunits, 0, null, replacementCodepoint)
            .whereType<int>());
  }

  /// Produce a String from a sequence of UTF-16LE encoded bytes. This method
  /// strips a leading BOM by default, but can be overridden by setting the
  /// optional parameter [stripBom] to false. Set the [replacementCodepoint] to
  /// null to throw an ArgumentError rather than replace the bad value.
  /// The default value for the [replacementCodepoint] is U+FFFD.
  String decodeUtf16Le(List<int> bytes,
      [int offset = 0,
      int? length,
      bool stripBom = true,
      int replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
    var codeunits = (Utf16leBytesToCodeUnitsDecoder(
            bytes, offset, length, stripBom, replacementCodepoint))
        .decodeRest();
    return String.fromCharCodes(
        utf16CodeUnitsToCodepoints(codeunits, 0, null, replacementCodepoint)
            .whereType<int>());
  }
}

const Utf16Codec utf16 = Utf16Codec();

/// Identifies whether a List of bytes starts (based on offset) with a
/// byte-order marker (BOM).
bool hasUtf16Bom(List<int> utf32EncodedBytes, [int offset = 0, int? length]) {
  return hasUtf16BeBom(utf32EncodedBytes, offset, length) ||
      hasUtf16LeBom(utf32EncodedBytes, offset, length);
}

/// Identifies whether a List of bytes starts (based on offset) with a
/// big-endian byte-order marker (BOM).
bool hasUtf16BeBom(List<int> utf16EncodedBytes, [int offset = 0, int? length]) {
  var end = length != null ? offset + length : utf16EncodedBytes.length;
  return (offset + 2) <= end &&
      utf16EncodedBytes[offset] == unicodeUtfBomHi &&
      utf16EncodedBytes[offset + 1] == unicodeUtfBomLo;
}

/// Identifies whether a List of bytes starts (based on offset) with a
/// little-endian byte-order marker (BOM).
bool hasUtf16LeBom(List<int> utf16EncodedBytes, [int offset = 0, int? length]) {
  var end = length != null ? offset + length : utf16EncodedBytes.length;
  return (offset + 2) <= end &&
      utf16EncodedBytes[offset] == unicodeUtfBomLo &&
      utf16EncodedBytes[offset + 1] == unicodeUtfBomHi;
}

/// Convert UTF-16 encoded bytes to UTF-16 code units by grouping 1-2 bytes
/// to produce the code unit (0-(2^16)-1). Relies on BOM to determine
/// endian-ness, and defaults to BE.
abstract class Utf16BytesToCodeUnitsDecoder implements ListRangeIterator {
  // TODO(kevmoo): should this field be private?
  final ListRangeIterator utf16EncodedBytesIterator;
  final int? replacementCodepoint;
  late int _current;

  Utf16BytesToCodeUnitsDecoder._fromListRangeIterator(
    this.utf16EncodedBytesIterator,
    this.replacementCodepoint,
  );

  factory Utf16BytesToCodeUnitsDecoder(
    List<int> utf16EncodedBytes, [
    int offset = 0,
    int? length,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint,
  ]) {
    length ??= utf16EncodedBytes.length - offset;
    if (hasUtf16BeBom(utf16EncodedBytes, offset, length)) {
      return Utf16beBytesToCodeUnitsDecoder(utf16EncodedBytes, offset + 2,
          length - 2, false, replacementCodepoint);
    } else if (hasUtf16LeBom(utf16EncodedBytes, offset, length)) {
      return Utf16leBytesToCodeUnitsDecoder(utf16EncodedBytes, offset + 2,
          length - 2, false, replacementCodepoint);
    } else {
      return Utf16beBytesToCodeUnitsDecoder(
          utf16EncodedBytes, offset, length, false, replacementCodepoint);
    }
  }

  /// Provides a fast way to decode the rest of the source bytes in a single
  /// call. This method trades memory for improved speed in that it potentially
  /// over-allocates the List containing results.
  List<int> decodeRest() {
    final codeunits = List<int>.filled(remaining, 0);
    var i = 0;
    while (moveNext()) {
      codeunits[i++] = current;
    }
    if (i == codeunits.length) {
      return codeunits;
    } else {
      return codeunits.sublist(0, i);
    }
  }

  @override
  int get current => _current;

  @override
  bool moveNext() {
    var remaining = utf16EncodedBytesIterator.remaining;
    if (remaining == 0) {
      return false;
    }
    if (remaining == 1) {
      utf16EncodedBytesIterator.moveNext();
      if (replacementCodepoint != null) {
        _current = replacementCodepoint!;
        return true;
      } else {
        throw ArgumentError(
          'Invalid UTF16 at ${utf16EncodedBytesIterator.position}',
        );
      }
    }
    _current = decode();
    return true;
  }

  @override
  int get position => utf16EncodedBytesIterator.position ~/ 2;

  @override
  void backup([int by = 1]) {
    utf16EncodedBytesIterator.backup(2 * by);
  }

  @override
  int get remaining => (utf16EncodedBytesIterator.remaining + 1) ~/ 2;

  @override
  void skip([int count = 1]) {
    utf16EncodedBytesIterator.skip(2 * count);
  }

  int decode();
}

/// Convert UTF-16BE encoded bytes to utf16 code units by grouping 1-2 bytes
/// to produce the code unit (0-(2^16)-1).
class Utf16beBytesToCodeUnitsDecoder extends Utf16BytesToCodeUnitsDecoder {
  Utf16beBytesToCodeUnitsDecoder(
    List<int> utf16EncodedBytes, [
    int offset = 0,
    int? length,
    bool stripBom = true,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint,
  ]) : super._fromListRangeIterator(
            (ListRange(utf16EncodedBytes, offset, length)).iterator,
            replacementCodepoint) {
    if (stripBom && hasUtf16BeBom(utf16EncodedBytes, offset, length)) {
      skip();
    }
  }

  @override
  int decode() {
    utf16EncodedBytesIterator.moveNext();
    var hi = utf16EncodedBytesIterator.current;
    utf16EncodedBytesIterator.moveNext();
    var lo = utf16EncodedBytesIterator.current;
    return (hi << 8) + lo;
  }
}

/// Convert UTF-16LE encoded bytes to utf16 code units by grouping 1-2 bytes
/// to produce the code unit (0-(2^16)-1).
class Utf16leBytesToCodeUnitsDecoder extends Utf16BytesToCodeUnitsDecoder {
  Utf16leBytesToCodeUnitsDecoder(
    List<int> utf16EncodedBytes, [
    int offset = 0,
    int? length,
    bool stripBom = true,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint,
  ]) : super._fromListRangeIterator(
            (ListRange(utf16EncodedBytes, offset, length)).iterator,
            replacementCodepoint) {
    if (stripBom && hasUtf16LeBom(utf16EncodedBytes, offset, length)) {
      skip();
    }
  }

  @override
  int decode() {
    utf16EncodedBytesIterator.moveNext();
    var lo = utf16EncodedBytesIterator.current;
    utf16EncodedBytesIterator.moveNext();
    var hi = utf16EncodedBytesIterator.current;
    return (hi << 8) + lo;
  }
}
