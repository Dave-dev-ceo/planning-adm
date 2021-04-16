import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_bar/navbar_item.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_bar/navbar_logo.dart';

class NavigationBarTableDesktop extends StatelessWidget {
  const NavigationBarTableDesktop({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[700],
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            NavBarLogo(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NavBarItem('Invitados'),
                SizedBox(width: 60,),
                NavBarItem('Involucrados'),
                SizedBox(width: 60,),
                NavBarItem('Proveedores'),
                SizedBox(width: 60,),
                NavBarItem('Mesas'),
                SizedBox(width: 20,),
              ],

            ),
        ],
      ),
    );
  }
}