import 'constants.dart';
import 'list_range.dart';
import 'utf_16_code_unit_decoder.dart';

/// TODO(jmesserly): would be nice to have this on String (dartbug.com/6501).
/// Provide a list of Unicode codepoints for a given string.
List<int?> stringToCodepoints(String str) {
  // Note: str.codeUnits gives us 16-bit code units on all Dart implementations.
  // So we need to convert.
  return utf16CodeUnitsToCodepoints(str.codeUnits);
}

/// Decodes the utf16 codeunits to codepoints.
List<int?> utf16CodeUnitsToCodepoints(List<int?> utf16CodeUnits,
    [int offset = 0,
    int? length,
    int replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
  var source = (ListRange(utf16CodeUnits, offset, length)).iterator;
  var decoder =
      Utf16CodeUnitDecoder.fromListRangeIterator(source, replacementCodepoint);
  var codepoints = <int?>[]..length = source.remaining;
  var i = 0;
  while (decoder.moveNext()) {
    codepoints[i++] = decoder.current;
  }
  if (i == codepoints.length) {
    return codepoints;
  } else {
    var codepointTrunc = <int?>[]..length = i;
    codepointTrunc.setRange(0, i, codepoints);
    return codepointTrunc;
  }
}

/// Encode code points as UTF16 code units.
List<int?> codepointsToUtf16CodeUnits(List<int> codepoints,
    [int offset = 0,
    int? length,
    int? replacementCodepoint = unicodeReplacementCharacterCodepoint]) {
  var listRange = ListRange(codepoints, offset, length);
  var encodedLength = 0;
  for (var value in listRange) {
    if (null == value) {
      continue;
    }

    if ((value >= 0 && value < unicodeUtf16ReservedLo) ||
        (value > unicodeUtf16ReservedHi && value <= unicodePlaneOneMax)) {
      encodedLength++;
    } else if (value > unicodePlaneOneMax && value <= unicodeValidRangeMax) {
      encodedLength += 2;
    } else {
      encodedLength++;
    }
  }

  var codeUnitsBuffer = <int?>[]..length = encodedLength;
  var j = 0;
  for (var value in listRange) {
    if (null == value) {
      continue;
    }
    if ((value >= 0 && value < unicodeUtf16ReservedLo) ||
        (value > unicodeUtf16ReservedHi && value <= unicodePlaneOneMax)) {
      codeUnitsBuffer[j++] = value;
    } else if (value > unicodePlaneOneMax && value <= unicodeValidRangeMax) {
      var base = value - unicodeUtf16Offset;
      codeUnitsBuffer[j++] =
          unicodeUtf16SurrogateUnit0Base + ((base & unicodeUtf16HiMask) >> 10);
      codeUnitsBuffer[j++] =
          unicodeUtf16SurrogateUnit1Base + (base & unicodeUtf16LoMask);
    } else if (replacementCodepoint != null) {
      codeUnitsBuffer[j++] = replacementCodepoint;
    } else {
      throw ArgumentError('Invalid encoding');
    }
  }
  return codeUnitsBuffer;
}
