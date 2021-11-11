//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter_keyboard_visibility_web/flutter_keyboard_visibility_web.dart';
import 'package:native_pdf_renderer/src/web/native_pdf_renderer_plugin.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:syncfusion_flutter_pdfviewer_web/pdfviewer_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FilePickerWeb.registerWith(registrar);
  FlutterKeyboardVisibilityPlugin.registerWith(registrar);
  NativePdfRendererPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  SyncfusionFlutterPdfViewerPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
