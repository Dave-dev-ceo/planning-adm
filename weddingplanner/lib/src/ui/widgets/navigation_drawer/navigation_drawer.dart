import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_drawer/drawer_item.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_drawer/navigation_drawer_header.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16)
        ]
      ),
      child: Column(
        children: <Widget>[
          NavigationDrawerHeader(),
          DrawerItem('Invitados', Icons.people),
          DrawerItem('Involucrados', Icons.people),
          DrawerItem('Proveedores', Icons.card_travel_sharp),
          DrawerItem('Mesas', Icons.backup_table),
        ],),
    );
  }
}