import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: 120, 
      height: 150,
      child: Image.asset('assets/logo.png'),
    );
  }
}