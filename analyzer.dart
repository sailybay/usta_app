import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('analyze_log.json');
  final contents = file.readAsStringSync(encoding: utf16); // or unicode
  final map = jsonDecode(contents);
  final out = File('analyze_out.utf8.txt');
  final sb = StringBuffer();
  for (var diag in map['diagnostics']) {
    final file = diag['location']['file'].toString().split('lib\\').last;
    sb.writeln(
      '${file}:${diag['location']['range']['start']['line']} - ${diag['problemMessage']}',
    );
  }
  out.writeAsStringSync(sb.toString(), encoding: utf8);
}

const Utf16Codec utf16 = Utf16Codec();

class Utf16Codec extends Encoding {
  const Utf16Codec();
  @override
  String get name => 'utf-16le';
  @override
  Converter<List<int>, String> get decoder => Utf16Decoder();
  @override
  Converter<String, List<int>> get encoder => throw UnimplementedError();
}

class Utf16Decoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) {
    if (input.isEmpty) return '';
    if (input[0] == 0xFF && input[1] == 0xFE) input = input.sublist(2); // BOM
    final chars = <int>[];
    for (int i = 0; i < input.length; i += 2) {
      if (i + 1 < input.length) {
        chars.add(input[i] | (input[i + 1] << 8));
      }
    }
    return String.fromCharCodes(chars);
  }
}
