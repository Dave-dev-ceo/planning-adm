import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/cargar_excel_invitados.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';

class TabsPage extends StatefulWidget {
  final int id;

  const TabsPage({Key key, this.id}) : super(key: key);
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: <BottomNavigationBarItem>[
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              title: tabItem.title,
            ),
        ],
      ),
    );
  }
}
class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;
  //int id = 0;
  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        /*TabNavigationItem(
          page: ListaInvitados(id: TabsPage().id,),
          icon: Icon(Icons.list),
          title: Text("Invitados"),
        ),*/
        TabNavigationItem(
          page: AgregarInvitados(id: TabsPage().id,),
          icon: Icon(Icons.add),
          title: Text("Agregar invitados"),
        ),
        TabNavigationItem(
          page: CargarExcel(id: TabsPage().id,),
          icon: Icon(Icons.table_chart_outlined),
          title: Text("Cargar Excel"),
        ),
      ];
}