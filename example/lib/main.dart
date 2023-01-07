// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:charset/charset.dart';

void main() {
  // '上善若水'
  print(utf16.decode([254, 255, 78, 10, 85, 132, 130, 229, 108, 52]));

// [254, 255, 78, 10, 85, 132, 130, 229, 108, 52]
  print(utf16.encode("上善若水"));

  String text = "上善若水";

  List<int> gbkData = gbk.encode(text);
// gbk.name
  print(Charset.detect(gbkData)?.name);

  List<int> eucJpData = eucJp.encode(text);

  // eucJp.name
  print(Charset.detect(
    eucJpData,
    orders: [ascii, eucJp, latin1],
  )?.name);

  List<int> shiftJisData = shiftJis.encode(text);
  // shiftJis.name
  print(Charset.detect(
    shiftJisData,
    orders: [ascii, shiftJis, latin1],
  )?.name);

  text = '상선이 물과 같다';
  List<int> eucKrData = eucKr.encode(text);
  // eucKr.name
  print(Charset.detect(
    eucKrData,
    orders: [ascii, eucKr, latin1],
  )?.name);

  text = 'ABC55/';
  List<int> asciiData = ascii.encode(text);
  // ascii.name
  print(Charset.detect(asciiData)?.name);

  String textl = "0x0atdaa\t\rRsad";
  // latin1.encode(textl)
  print(latin2.encode(textl));

  String toCheck = "that particularly stands out to me is \u0625\u0650"
      "\u062C\u064E\u0651\u0627\u0635 (\u02BE\u0101\u1E63) \"pear\", suggested to have originated from Hebrew "
      "\u05D0\u05B7\u05D2\u05B8\u05BC\u05E1 (ag\u00E1s)";
  List<Encoding> encoders = [
    "IBM437",
    "ISO-8859-2",
    "ISO-8859-3",
    "ISO-8859-4",
    "ISO-8859-5",
    //"ISO-8859-6",
    "ISO-8859-7",
    //"ISO-8859-8",
    "ISO-8859-9",
    //"ISO-8859-10",
    //"ISO-8859-11",
    "ISO-8859-13",
    //"ISO-8859-14",
    "ISO-8859-15",
    "ISO-8859-16",
    "windows-1250",
    "windows-1251",
    "windows-1252",
    "windows-1256",
    "Shift_JIS"
  ]
      .map<Encoding?>((name) => Charset.getByName(name))
      .whereType<Encoding>()
      .toList();
  List<Encoding> neededEncoders = [latin1];
  for (int code in toCheck.runes) {
    final char = String.fromCharCode(code);
    bool canEncode = false;
    for (Encoding encoder in neededEncoders) {
      if (Charset.canEncode(encoder, char)) {
        print("${encoder.name} $code ${encoder.encode(char).join(",")}");
        canEncode = true;
        break;
      }
    }
    if (!canEncode) {
      for (Encoding encoder in encoders) {
        if (Charset.canEncode(encoder, char)) {
          print("+${encoder.name} $code ${encoder.encode(char).join(",")}");
          canEncode = true;
          break;
        }
      }
    }
    if (!canEncode) {
      print("+ utf $code");
    }
  }
}
