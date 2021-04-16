//import 'dart:js';

import 'package:flutter/material.dart';
//import 'package:weddingplanner/src/ui/Tabs/pages_taps/tabs_page.dart';
import 'package:weddingplanner/src/ui/home/home.dart';

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
        '/':(context) => HomeView(),
        //'/':(context) => HomeView(),
        //'/':(context) => TabsPage(), 
      },
      //home: TabsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

