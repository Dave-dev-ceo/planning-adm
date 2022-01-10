import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
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
      final path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
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
            .showNotification(1, 'Se descargo el archivo', result, 4);
      }
    } else {
      print('NO HAY PERMISO');
    }
  }
}
