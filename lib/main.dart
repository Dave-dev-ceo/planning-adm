import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planning/src/utils/notifications_service.dart';
import 'src/app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await NoticationsService().initNotication();
  runApp(const AppState());
}
