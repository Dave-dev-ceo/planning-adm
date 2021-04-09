import 'package:flutter/material.dart';
import '../../lista_invitados.dart';
import '../../agregar_invitado.dart';
import '../../cargar_excel_invitados.dart';
class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

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
          title: Text("Caragar Excel"),
        ),
      ];
}