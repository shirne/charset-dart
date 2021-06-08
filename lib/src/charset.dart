import 'dart:convert';

class Charset {
  static final _charCodeMap = {};
  Charset._();
  static Encoding? detect(List<int> bytes,
      [Encoding? defaultEncoding, List<Encoding>? orders]) {}

  static Encoding? getByName(String codeName) {}

  static void register(Encoding encoding, String name, List<String> alias) {}
}
