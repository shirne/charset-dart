import 'dart:convert';

import 'code_page.dart';
import 'euc_jp.dart';
import 'euc_kr.dart';
import 'gbk.dart';
import 'shift_jis.dart';
import 'utf/utf16.dart';
import 'utf/utf32.dart';

class Charset {
  static final _charCodeMap = <String, Encoding>{
    'iso-ir-101': latin2,
    'iso_8859-2': latin2,
    'iso-8859-2': latin2,
    'latin2': latin2,
    'l2': latin2,
    'csisolatin2': latin2,

    'iso-ir-109': latin3,
    'iso_8859-3': latin3,
    'iso-8859-3': latin3,
    'latin3': latin3,
    'l3': latin3,
    'csisolatin3': latin3,

    'iso-ir-110': latin4,
    'iso_8859-4': latin4,
    'iso-8859-4': latin4,
    'latin4': latin4,
    'l4': latin4,
    'csisolatin4': latin4,

    'iso-ir-144': latinCyrillic,
    'iso_8859-5': latinCyrillic,
    'iso-8859-5': latinCyrillic,
    'cyrillic': latinCyrillic,
    'csisolatincyrillic': latinCyrillic,

    'iso-ir-127': latinArabic,
    'iso_8859-6': latinArabic,
    'iso-8859-6': latinArabic,
    'ecma-114': latinArabic,
    'asmo-708': latinArabic,
    'arabic': latinArabic,
    'csisolatinarabic': latinArabic,

    'iso-ir-126': latinGreek,
    'iso_8859-7': latinGreek,
    'iso-8859-7': latinGreek,
    'elot_928': latinGreek,
    'ecma-118': latinGreek,
    'greek': latinGreek,
    'greek8': latinGreek,
    'csisolatingreek': latinGreek,

    'iso-ir-138': latinHebrew,
    'iso_8859-8': latinHebrew,
    'iso-8859-8': latinHebrew,
    'hebrew': latinHebrew,
    'csisolatinhebrew': latinHebrew,

    'iso-ir-148': latin5,
    'iso_8859-9': latin5,
    'iso-8859-9': latin5,
    'latin5': latin5,
    'l5': latin5,
    'csisolatin5': latin5,

    'iso-ir-157': latin6,
    'l6': latin6,
    'iso-8859-10': latin6,
    'iso_8859-10': latin6,
    'iso_8859-10:1992': latin6,
    'csisolatin6': latin6,
    'latin6': latin6,

    'tis-620': latinThai,
    'cstis620': latinThai,
    'iso-8859-11': latinThai,

    'iso-8859-13': latin7,
    'csiso885913': latin7,

    'iso-8859-14': latin8,
    'iso-ir-199': latin8,
    'iso_8859-14:1998': latin8,
    'iso_8859-14': latin8,
    'latin8': latin8,
    'iso-celtic': latin8,
    'l8': latin8,
    'csiso885914': latin8,

    'iso-8859-15': latin9,
    'iso_8859-15': latin9,
    'latin-9': latin9,
    'csiso885915': latin9,

    'iso-8859-16': latin10,
    'iso-ir-226': latin10,
    'iso_8859-16:2001': latin10,
    'iso_8859-16': latin10,
    'latin10': latin10,
    'l10': latin10,
    'csiso885916': latin10,

    // cp437
    '437': cp437,
    'cp437': cp437,
    'ibm437': cp437,
    'csibm437': cp437,
    'cspc8codepage437': cp437,

    '737': cp737,
    'cp737': cp737,
    'ibm737': cp737,
    'csibm737': cp737,

    '775': cp775,
    'cp775': cp775,
    'ibm775': cp775,
    'csibm775': cp775,

    '850': cp850,
    'cp850': cp850,
    'ibm850': cp850,
    'csibm850': cp850,

    '852': cp852,
    'cp852': cp852,
    'ibm852': cp852,
    'csibm852': cp852,

    '855': cp855,
    'cp855': cp855,
    'ibm855': cp855,
    'csibm855': cp855,

    '856': cp856,
    'cp856': cp856,
    'ibm856': cp856,
    'csibm856': cp856,

    '857': cp857,
    'cp857': cp857,
    'ibm857': cp857,
    'csibm857': cp857,

    '858': cp858,
    'cp858': cp858,
    'ibm858': cp858,
    'csibm858': cp858,

    '860': cp860,
    'cp860': cp860,
    'ibm860': cp860,
    'csibm860': cp860,

    '861': cp861,
    'cp861': cp861,
    'ibm861': cp861,
    'csibm861': cp861,

    '862': cp862,
    'cp862': cp862,
    'ibm862': cp862,
    'csibm862': cp862,

    '863': cp863,
    'cp863': cp863,
    'ibm863': cp863,
    'csibm863': cp863,

    '864': cp864,
    'cp864': cp864,
    'ibm864': cp864,
    'csibm864': cp864,

    '865': cp865,
    'cp865': cp865,
    'ibm865': cp865,
    'csibm865': cp865,

    '866': cp866,
    'cp866': cp866,
    'ibm866': cp866,
    'csibm866': cp866,

    '869': cp869,
    'cp869': cp869,
    'ibm869': cp869,
    'csibm869': cp869,

    '922': cp922,
    'cp922': cp922,
    'ibm922': cp922,
    'csibm922': cp922,

    '1046': cp1046,
    'cp1046': cp1046,
    'ibm1046': cp1046,
    'csibm1046': cp1046,

    '1124': cp1124,
    'cp1124': cp1124,
    'ibm1124': cp1124,
    'csibm1124': cp1124,

    '1125': cp1125,
    'cp1125': cp1125,
    'ibm1125': cp1125,
    'csibm1125': cp1125,

    '1129': cp1129,
    'cp1129': cp1129,
    'ibm1129': cp1129,
    'csibm1129': cp1129,

    '1133': cp1133,
    'cp1133': cp1133,
    'ibm1133': cp1133,
    'csibm1133': cp1133,

    '1161': cp1161,
    'cp1161': cp1161,
    'ibm1161': cp1161,
    'csibm1161': cp1161,

    '1162': cp1162,
    'cp1162': cp1162,
    'ibm1162': cp1162,
    'csibm1162': cp1162,

    '1163': cp1163,
    'cp1163': cp1163,
    'ibm1163': cp1163,
    'csibm1163': cp1163,

    '874': windows874,
    'cp874': windows874,
    'win874': windows874,
    'windows874': windows874,
    'windows-874': windows874,
    'cswindows874': windows874,

    '1250': windows1250,
    'cp1250': windows1250,
    'win1250': windows1250,
    'windows1250': windows1250,
    'windows-1250': windows1250,
    'cswindows1250': windows1250,

    '1251': windows1251,
    'cp1251': windows1251,
    'win1251': windows1251,
    'windows1251': windows1251,
    'windows-1251': windows1251,
    'cswindows1251': windows1251,

    '1252': windows1252,
    'cp1252': windows1252,
    'win1252': windows1252,
    'windows1252': windows1252,
    'windows-1252': windows1252,
    'cswindows1252': windows1252,

    '1253': windows1253,
    'cp1253': windows1253,
    'win1253': windows1253,
    'windows1253': windows1253,
    'windows-1253': windows1253,
    'cswindows1253': windows1253,

    '1254': windows1254,
    'cp1254': windows1254,
    'win1254': windows1254,
    'windows1254': windows1254,
    'windows-1254': windows1254,
    'cswindows1254': windows1254,

    '1255': windows1255,
    'cp1255': windows1255,
    'win1255': windows1255,
    'windows1255': windows1255,
    'windows-1255': windows1255,
    'cswindows1255': windows1255,

    '1256': windows1256,
    'cp1256': windows1256,
    'win1256': windows1256,
    'windows1256': windows1256,
    'windows-1256': windows1256,
    'cswindows1256': windows1256,

    '1257': windows1257,
    'cp1257': windows1257,
    'win1257': windows1257,
    'windows1257': windows1257,
    'windows-1257': windows1257,

    '1258': windows1258,
    'cp1258': windows1258,
    'win1258': windows1258,
    'windows1258': windows1258,
    'windows-1258': windows1258,

    // euc-jp
    'euc-jp': eucJp,
    'eucjp': eucJp,
    'euc_jp': eucJp,
    'cseucpkdfmtjapanese': eucJp,

    'euc-kr': eucKr,
    'euckr': eucKr,
    'euc_kr': eucKr,
    'cseuckr': eucKr,

    'gbk': gbk,
    'gb2312': gbk,
    'gb-2312': gbk,
    'gb_2312': gbk,
    'cp936': gbk,
    'ms936': gbk,
    'windows-936': gbk,
    'csgbk': gbk,

    'gb18030': gbk,
    'csgb18030': gbk,

    'shift-jis': shiftJis,
    'shiftjis': shiftJis,
    'shift_jis': shiftJis,
    'ms_kanji': shiftJis,
    'csshiftjis': shiftJis,

    'utf-16': utf16,
    'utf16': utf16,
    'utf_16': utf16,
    'csutf16': utf16,
    'csutf16be': utf16,
    'csutf16le': utf16,
    'utf-16be': utf16,
    'utf-16le': utf16,

    'utf-32': utf32,
    'utf32': utf32,
    'utf_32': utf32,
    'csutf32': utf32,
    'csutf32be': utf32,
    'utf-32be': utf32,
    'csutf32le': utf32,
    'utf-32le': utf32
  };
  Charset._();
  static Encoding? detect(List<int> bytes,
      [Encoding? defaultEncoding, List<Encoding>? orders]) {
    //TODO implemention
    return null;
  }

  static Encoding? getByName(String codeName, [Encoding? defaultEncoding]) {
    return _charCodeMap[codeName.toLowerCase()] ??
        Encoding.getByName(codeName) ??
        defaultEncoding;
  }

  static void register(Encoding encoding, String name, [List<String>? alias]) {
    _charCodeMap[name.toLowerCase()] = encoding;
    if (alias != null) {
      for (String aliaName in alias) {
        _charCodeMap[aliaName.toLowerCase()] = encoding;
      }
    }
  }

  static bool canEncode(Encoding? encoding, String char) {
    if (encoding == null) return false;
    try {
      List<int> result = encoding.encode(char);
      if (encoding is CodePage) {
        if (result.length != char.length) {
          return false;
        }
      } else if (!encoding.name.contains('utf')) {
        if (result.contains(0xFFFD)) {
          return false;
        }
      }
    } on FormatException catch (_) {
      return false;
    } on ArgumentError catch (_) {
      return false;
    }
    return true;
  }

  static bool canDecode(Encoding? encoding, List<int> char) {
    if (encoding == null) return false;
    try {
      String result = encoding.decode(char);
      if (encoding is CodePage) {
        if (result.contains('\uFFFD')) {
          return false;
        }
      } else if (!encoding.name.contains('utf')) {
        // TODO
        if (result.contains('\uFFFD')) {
          return false;
        }
      }
    } on FormatException catch (_) {
      return false;
    } on ArgumentError catch (_) {
      return false;
    }
    return true;
  }
}
