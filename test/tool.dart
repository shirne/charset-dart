import 'dart:convert';
import 'dart:io';

void main() {
  final stringData = File('test/resource/cp949.json').readAsStringSync();
  final parts = jsonDecode(stringData);
  final data = <int, int>{};
  for (List part in parts) {
    int start = int.parse(part[0], radix: 16);
    int lastCode = 0;
    for (var i in part.sublist(1)) {
      if (i is String) {
        for (int code in i.codeUnits) {
          data[start] = code;
          lastCode = code;
          start++;
        }
      } else if (i is int) {
        for (int j = 0; j < i; j++) {
          data[start++] = ++lastCode;
        }
      }
    }
  }

  final sb = StringBuffer();
  final sb2 = StringBuffer();

  sb.write('const cp949ToUtf8 = {\n');
  sb2.write('const utf8ToCp949 = {\n');

  for (final entry in data.entries) {
    sb.write('${entry.key}:${entry.value},');
    sb2.write('${entry.value}:${entry.key},');
  }

  sb.write('};');
  sb2.write('};');

  File('cp949_table.dart').writeAsStringSync('${sb.toString()}\n'
      '${sb2.toString()}\n');
}
