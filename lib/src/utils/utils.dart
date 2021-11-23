import 'dart:convert';

import 'package:universal_html/html.dart' as html hide Text;

void downloadFile(String data, String titulo, {String extensionFile}) async {
  final date = DateTime.now();

  if (extensionFile == null) {
    extensionFile = 'pdf';
  }

  final bytes = base64Decode(data);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = '$titulo-$date.$extensionFile';
  html.document.body.children.add(anchor);
  anchor.click();
  html.document.body.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
