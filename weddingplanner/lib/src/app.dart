//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/resources/route_generator.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/login/login.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/invitados.dart';
//import 'package:weddingplanner/src/ui/Tabs/pages_taps/tabs_page.dart';
//import 'package:weddingplanner/src/ui/login/login.dart';

class MyApp extends StatelessWidget {
  Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFF880B55)),
        //backgroundColor: createMaterialColor(Color(0xD34444)),
        scaffoldBackgroundColor: hexToColor('#FFF9F9'),
        fontFamily: 'Comfortaa'
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      
      debugShowCheckedModeBanner: false,
    );
  }
}

