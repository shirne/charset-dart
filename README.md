# charset
[![pub package](https://img.shields.io/pub/v/charset.svg)](https://pub.dartlang.org/packages/charset)

gbk,euc-kr,euc-jp,shift-jis,cp437,utf-16 and utf-32 Encoding and Decoding Library for Dart Language

Arrange from <br />
[utf](https://github.com/dart-archive/utf)<br />
[fast_gbk](https://github.com/lixiangthinker/fast_gbk)<br />
[euc](https://github.com/dsh0416/euc-jp)

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

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
