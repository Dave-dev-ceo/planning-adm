import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html hide Text;

import 'notifications_service.dart';

void downloadFile(String data, String tituloTemp,
    {String extensionFile}) async {
  final date = DateTime.now();
  String titulo;

  if (tituloTemp == 'Plantilla') {
    titulo = tituloTemp;
  } else {
    titulo = tituloTemp + '-' + date.toString();
  }

  extensionFile ??= 'pdf';

  final bytes = base64Decode(data);
  if (kIsWeb) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$titulo.$extensionFile';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  } else {
    PermissionStatus status = await Permission.storage.request();
    //PermissionStatus statusManager =
    //    await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      String path;
      if (Platform.isAndroid) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
        if (deviceInfo.version.sdkInt >= 30) {
          path =
              await getExternalStorageDirectory().then((value) => value.path);
        } else {
          path = await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS);
        }
      } else {
        path = await getApplicationDocumentsDirectory()
            .then((value) => value.path);
      }
      File f = File('$path/$titulo.$extensionFile');
      Map<String, dynamic> result = {
        'message': '$titulo.$extensionFile',
        'filePath': null,
        'error': null,
      };
      try {
        await f.writeAsBytes(bytes);
        result['filePath'] = f.path;
        NoticationsService()
            .showNotification(1, 'Se descargó el archivo', result, 2);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      await openAppSettings();
      if (kDebugMode) {
        print('NO HAY PERMISO');
      }
    }
  }
}
