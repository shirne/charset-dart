# charset
[![pub package](https://img.shields.io/pub/v/charset.svg)](https://pub.dartlang.org/packages/charset)

cp series,win series,iso series,gbk,euc-kr,euc-jp,shift-jis,cp437,utf-16 and utf-32 Encoding and Decoding Library for Dart Language

Arrange from <br />
[utf](https://github.com/dart-archive/utf)<br />
[fast_gbk](https://github.com/lixiangthinker/fast_gbk)<br />
[euc](https://github.com/dsh0416/euc-jp)
[convert](https://github.com/dart-lang/convert)

## Examples

```dart
import 'package:charset/charset.dart';

main() {
  // default
  print(utf16.decode([254, 255, 78, 10, 85, 132, 130, 229, 108, 52]));

  print(utf16.encode("上善若水"));

  // detect
  print(hasUtf16Bom([0xFE, 0xFF, 0x6C, 0x34]));

  // advance
  Utf16Encoder encoder = utf16.encoder as Utf16Encoder;
  print(encoder.encodeUtf16Be("上善若水", false));
  print(encoder.encodeUtf16Le("上善若水", true));
}
```

## Notice

In 0.x versions CodePage series Does not containts control characters (0x00-0x31).
0.x 版本中CodePage不含控制字符 (0x00-0x31)