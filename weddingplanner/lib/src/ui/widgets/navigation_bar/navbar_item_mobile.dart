import 'package:flutter/material.dart';

class NavBarItemMobile extends StatelessWidget {
  final String title;
  const NavBarItemMobile(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: 18, color: Colors.purple[700]),);
  }
}