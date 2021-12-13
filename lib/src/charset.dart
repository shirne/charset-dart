import 'dart:convert';

import 'package:charset/charset.dart';

import 'cp437.dart';
import 'euc_jp.dart';
import 'euc_kr.dart';
import 'gbk.dart';
import 'shift_jis.dart';

class Charset {
  static final _charCodeMap = <String, Encoding>{
    // cp437
    'cp437': cp437,
    'cp-437': cp437,
    'cp_437': cp437,

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
