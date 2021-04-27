//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/home/home.dart';
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
        //'/':(context) => HomeView(),
        //'/':(context) => LoginScreen(),
        //'/':(context) => DashboardEventos(),
        //'/eventos':(context) => HomeView(),
        DashboardEventos.routeName:(context) => DashboardEventos(),
        HomeView.routeName:(context) => HomeView(), 
      },
      //home: TabsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

