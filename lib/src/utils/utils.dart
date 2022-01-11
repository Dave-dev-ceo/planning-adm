import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html hide Text;

import 'notifications_service.dart';

void downloadFile(String data, String titulo, {String extensionFile}) async {
  final date = DateTime.now();

  if (extensionFile == null) {
    extensionFile = 'pdf';
  }

  final bytes = base64Decode(data);
  if (kIsWeb) {
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
  } else {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      String path;
      if (Platform.isAndroid) {
        path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
      } else {
        path = await getApplicationDocumentsDirectory()
            .then((value) => value.path);
      }
      File f = File('$path/$titulo-$date.$extensionFile');
      Map<String, dynamic> result = {
        'message': '$titulo-$date.$extensionFile',
        'filePath': null,
        'error': null,
      };
      try {
        f.writeAsBytesSync(bytes);
        result['filePath'] = f.path;
      } catch (e) {
        print(e);
      } finally {
        NoticationsService()
            .showNotification(1, 'Se descargó el archivo', result, 2);
      }
    } else {
      print('NO HAY PERMISO');
    }
  }
}
