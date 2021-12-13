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
    // cp437
    '437': cp437,
    'cp437': cp437,
    'ibm437': cp437,
    'csibm437': cp437,

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

    '1250': windows1250,
    'cp1250': windows1250,
    'win1250': windows1250,
    'windows1250': windows1250,

    '1251': windows1251,
    'cp1251': windows1251,
    'win1251': windows1251,
    'windows1251': windows1251,

    '1252': windows1252,
    'cp1252': windows1252,
    'win1252': windows1252,
    'windows1252': windows1252,

    '1253': windows1253,
    'cp1253': windows1253,
    'win1253': windows1253,
    'windows1253': windows1253,

    '1254': windows1254,
    'cp1254': windows1254,
    'win1254': windows1254,
    'windows1254': windows1254,

    '1255': windows1255,
    'cp1255': windows1255,
    'win1255': windows1255,
    'windows1255': windows1255,

    '1256': windows1256,
    'cp1256': windows1256,
    'win1256': windows1256,
    'windows1256': windows1256,

    '1257': windows1257,
    'cp1257': windows1257,
    'win1257': windows1257,
    'windows1257': windows1257,

    '1258': windows1258,
    'cp1258': windows1258,
    'win1258': windows1258,
    'windows1258': windows1258,

    // euc-jp
    'euc-jp': eucJp,
    'eucjp': eucJp,
    'euc_jp': eucJp,

    'euc-kr': eucKr,
    'euckr': eucKr,
    'euc_kr': eucKr,

    'gbk': gbk,
    'gb2312': gbk,
    'gb-2312': gbk,
    'gb_2312': gbk,

    'shift-jis': shiftJis,
    'shiftjis': shiftJis,
    'shift_jis': shiftJis,

    'utf-16': utf16,
    'utf16': utf16,
    'utf_16': utf16,

    'utf-32': utf32,
    'utf32': utf32,
    'utf_32': utf32
  };
  Charset._();
  static Encoding? detect(List<int> bytes,
      [Encoding? defaultEncoding, List<Encoding>? orders]) {}

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
      encoding.encode(char);
    } on FormatException catch (_) {
      return false;
    }
    return true;
  }

  static bool canDecode(Encoding? encoding, List<int> char) {
    if (encoding == null) return false;
    try {
      encoding.decode(char);
    } on FormatException catch (_) {
      return false;
    }
    return true;
  }
}
