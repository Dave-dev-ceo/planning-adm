import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_bar/navbar_logo.dart';

class NavigationBarMobile extends StatelessWidget {
  const NavigationBarMobile({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.purple[700],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu), 
            onPressed: (){},
            color: Colors.white,),
            NavBarLogo(),
        ],
      ),
    );
  }
}