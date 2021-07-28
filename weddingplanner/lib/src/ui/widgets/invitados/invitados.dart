import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/permisos/permisos_bloc.dart';
import 'package:weddingplanner/src/models/model_perfilado.dart';
import 'package:weddingplanner/src/ui/Resumen/resumen_evento.dart';
import 'package:weddingplanner/src/ui/construccion/construccion.dart';
import 'package:weddingplanner/src/ui/contratos/contrato.dart';
import 'package:weddingplanner/src/ui/listas/Listas.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';
import 'package:weddingplanner/src/ui/widgets/tab/tab_item.dart';
import 'package:weddingplanner/src/ui/asistencia/asistencia.dart';
import 'package:weddingplanner/src/ui/timing_evento/timings_eventos.dart';

class Invitados extends StatefulWidget {
  //static const routeName = '/eventos';
  final Map<dynamic, dynamic> detalleEvento;
  const Invitados({Key key, this.detalleEvento}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState(detalleEvento);
}

class _InvitadosState extends State<Invitados> {
  //SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final Map<dynamic, dynamic> detalleEvento;
  int _pageIndex = 0;
  int _pages = 0;
  PermisosBloc permisosBloc;

  _InvitadosState(this.detalleEvento);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void initState() {
    permisosBloc = BlocProvider.of<PermisosBloc>(context);
    permisosBloc.add(obtenerPermisosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: BlocBuilder<PermisosBloc, PermisosState>(
        builder: (context, state) {
          if (state is PermisosInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ErrorTokenPermisos) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadingPermisos) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PermisosOk) {
            List<TabItem> tabs = obtenerTabsPantallas(state.permisos
                .pantallas); /* <TabItem>[TabItem(titulo: 'test', icono: Icons.ac_unit)]; */
            List<Widget> pantallas = obtenerPantallasContent(state.permisos
                .pantallas); /* <Widget>[Center(child: Text('Test'))]; */
            // Navigator.pop(_dialogContext);
            return crearPantallas(context, tabs, pantallas);
          } else if (state is ErrorPermisos) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(child: Text('Sin permisos'));
          }
        },
      ),
    );
  }

  Widget crearPantallas(BuildContext context, List<TabItem> pantallasTabs,
      List<Widget> PantallasCOntent) {
    return DefaultTabController(
        length: _pages,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Center(
              child: FittedBox(
                  child: Image.asset(
                'assets/logo.png',
                height: 100.0,
                width: 250.0,
              )),
            ),
            toolbarHeight: 150.0,
            backgroundColor: hexToColor('#880B55'),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('CONFIGURACIÓN EVENTO'),
              ),
              Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    child: Text('MF'),
                    backgroundColor: hexToColor('#d39942'),
                  ))
            ],
            bottom: TabBar(
                onTap: (int index) {
                  setState(
                    () {
                      _pageIndex = index;
                    },
                  );
                },
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: pantallasTabs
                //  [
                // TabItem(titulo: 'Resumen', icono: Icons.list),
                // TabItem(titulo: 'Invitados', icono: Icons.people),
                // TabItem(titulo: 'Timings', icono: Icons.access_time_sharp),
                // TabItem(titulo: 'Proveedores', icono: Icons.support_agent_outlined),
                // TabItem(titulo: 'Inventario', icono: Icons.featured_play_list_outlined),
                // TabItem(titulo: 'Presupuesto', icono: Icons.attach_money_sharp),
                // TabItem(titulo: 'Autorizaciones', icono: Icons.lock_open),
                // TabItem(titulo: 'Contratos', icono: Icons.description_outlined),
                // TabItem(titulo: 'Asistencia', icono: Icons.accessibility),
                // ],
                ),
          ),
          body: SafeArea(
            child: IndexedStack(index: _pageIndex, children: PantallasCOntent
                // <Widget> [
                // ResumenEvento(
                //   detalleEvento: detalleEvento,
                // ),
                // ListaInvitados(
                //   idEvento: detalleEvento['idEvento'],
                // ),
                // TimingsEventos(),
                // Construccion(),
                // Construccion(),
                // Construccion(),
                // Construccion(),
                // Contratos(),
                // Asistencia()
                // ],
                ),
          ),
        ));
  }

  List<TabItem> obtenerTabsPantallas(ItemModelPantallas pantallas) {
    List<TabItem> tabs = [];
    int temp = 0;
    if (pantallas != null) {
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES')) {
        tabs.add(TabItem(titulo: 'Resumen', icono: Icons.list));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
        tabs.add(TabItem(titulo: 'Invitados', icono: Icons.people));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')) {
        tabs.add(
            TabItem(titulo: 'Actividades', icono: Icons.access_time_sharp));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')) {
        tabs.add(TabItem(
            titulo: 'Proveedores', icono: Icons.support_agent_outlined));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-IVT')) {
        tabs.add(TabItem(
            titulo: 'Inventario', icono: Icons.featured_play_list_outlined));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRS')) {
        tabs.add(
            TabItem(titulo: 'Presupuesto', icono: Icons.attach_money_sharp));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-AUT')) {
        tabs.add(TabItem(titulo: 'Autorizaciones', icono: Icons.lock_open));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')) {
        tabs.add(
            TabItem(titulo: 'Contratos', icono: Icons.description_outlined));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI')) {
        tabs.add(TabItem(titulo: 'Asistencia', icono: Icons.accessibility));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-ART')) {
        tabs.add(TabItem(titulo: 'Listas', icono: Icons.list));
        temp += 1;
      }
      _pages = temp;
      return tabs;
    } else {
      _pages += 1;
      return [TabItem(titulo: 'Sin permisos', icono: Icons.block)];
    }
  }

  List<Widget> obtenerPantallasContent(ItemModelPantallas pantallas) {
    List<Widget> temp = [];
    if (pantallas != null) {
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES')) {
        temp.add(ResumenEvento(
          detalleEvento: detalleEvento,
          WP_EVT_RES_EDT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES-EDT'),
        ));
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
        temp.add(ListaInvitados(
          idEvento: detalleEvento['idEvento'],
          WP_EVT_INV_CRT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
          WP_EVT_INV_EDT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
          WP_EVT_INV_ENV: pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
        ));
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')) {
        temp.add(TimingsEventos());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')) {
        temp.add(Construccion());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-IVT')) {
        temp.add(Construccion());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRS')) {
        temp.add(Construccion());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-AUT')) {
        temp.add(Construccion());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')) {
        temp.add(Contratos());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI')) {
        temp.add(Asistencia());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-ART')) {
        temp.add(Listas());
      }
      return temp;
    } else {
      return [
        Center(
          child: Text('Sin permisos.'),
        )
      ];
    }
  }
}
