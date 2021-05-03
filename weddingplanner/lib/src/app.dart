//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/home/home.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/invitados.dart';
//import 'package:weddingplanner/src/ui/Tabs/pages_taps/tabs_page.dart';
//import 'package:weddingplanner/src/ui/login/login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        //'/':(context) => FullScreenDialogEdit(),
        //'/':(context) => Invitados(),
        //'/':(context) => LoginScreen(),
        //'/':(context) => DashboardEventos(),
        //'/eventos':(context) => HomeView(),
        DashboardEventos.routeName:(context) => DashboardEventos(),
        Invitados.routeName:(context) => Invitados(), 
      },
      //home: TabsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

