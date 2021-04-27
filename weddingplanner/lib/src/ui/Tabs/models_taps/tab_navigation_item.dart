import 'package:flutter/material.dart';
//import 'package:weddingplanner/src/ui/home/home.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/cargar_excel_invitados.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';
//import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;
  int id = 0;
  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: ListaInvitados(),
          icon: Icon(Icons.list),
          title: Text("Invitados"),
        ),
        TabNavigationItem(
          page: AgregarInvitados(),
          icon: Icon(Icons.add),
          title: Text("Agregar invitados"),
        ),
        TabNavigationItem(
          page: CargarExcel(),
          icon: Icon(Icons.table_chart_outlined),
          title: Text("Cargar Excel"),
        ),
      ];
}