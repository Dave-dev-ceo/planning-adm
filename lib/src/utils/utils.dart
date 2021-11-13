import 'dart:convert';

import 'package:universal_html/html.dart' as html hide Text;

void buildPDFDownload(String data, String titulo) async {
  final date = DateTime.now();

  final bytes = base64Decode(data);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = '$titulo-$date.pdf';
  html.document.body.children.add(anchor);
  anchor.click();
  html.document.body.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
