//import 'dart:js';

import 'package:flutter/material.dart';
//import 'package:weddingplanner/src/ui/home.dart';
import 'package:weddingplanner/src/ui/lista_invitados.dart';
//import 'ui/Tabs/pages_taps/tabs_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => ListaInvitados(),
        //'/':(context) => TabsPage(), 
      },
      //home: TabsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

