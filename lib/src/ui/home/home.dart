// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/permisos/permisos_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/ui/dashboard_planner/dashboard_calendar_page.dart';
import 'package:planning/src/ui/eventos/dashboard_eventos.dart';
import 'package:planning/src/ui/machotes/machotes.dart';
import 'package:planning/src/ui/prospecto/prospectos_page.dart';
import 'package:planning/src/ui/proveedores/proveedores.dart';
import 'package:planning/src/ui/timings/timing.dart';
import 'package:planning/src/ui/usuarios/usuarios.dart';
import 'package:planning/src/ui/widgets/tab/tab_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  //static const routeName = '/eventos';
  //final int idPlanner;
  final Map data;
  const Home({Key key, @required this.data}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  int _pageIndex = 0;
  int _pages = 0;
  PermisosBloc permisosBloc;
  BuildContext _dialogContext;
  String claveRol;

  ItemModelPerfil permisos;

  @override
  void initState() {
    permisosBloc = BlocProvider.of<PermisosBloc>(context);
    permisosBloc.add(ObtenerPermisosEvent());
    getClaveRol();
    super.initState();
  }

  getClaveRol() async {
    claveRol = await _sharedPreferences.getClaveRol();
  }

  //_HomeState(this.idPlanner);
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: BlocBuilder<PermisosBloc, PermisosState>(
        builder: (context, state) {
          if (state is PermisosInitial) {
            return const Center(
              child: LoadingCustom(),
            );
          } else if (state is ErrorTokenPermisos) {
            return _showDialogMsg(context);
          } else if (state is LoadingPermisos) {
            return const Center(child: LoadingCustom());
          } else if (state is PermisosOk) {
            permisos = state.permisos;
            List<TabItem> tabs = obtenerTabs(state.permisos
                .secciones); /* <TabItem>[TabItem(titulo: 'test', icono: Icons.ac_unit)]; */
            List<Widget> pantallas = obtenerPantallasSecciones(state.permisos
                .secciones); /* <Widget>[Center(child: Text('Test'))]; */
            // Navigator.pop(_dialogContext);
            return crearPantalla(context, tabs, pantallas);
          } else if (state is ErrorPermisos) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(child: Text('Sin permisos'));
          }
        },
      ),
    );
  }

  Widget crearPantalla(
      BuildContext context, List<Widget> tabs, List<Widget> pantallas) {
    return DefaultTabController(
        length: _pages,
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: FittedBox(
                    child: Image.asset(
                  'assets/new_logo.png',
                  height: 100.0,
                  width: 250.0,
                )),
              ),
              leading: const Center(
                child: Text('PLANNER',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              leadingWidth: 100.0,
              actions: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: PopupMenuButton(
                        child: widget.data['imag'] == null ||
                                widget.data['imag'] == ''
                            ? const FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              )
                            : CircleAvatar(
                                backgroundImage: MemoryImage(
                                  base64Decode(widget.data['imag']),
                                ),
                              ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Text("Perfil"),
                          ),
                          if (claveRol == 'SU')
                            const PopupMenuItem(
                                value: 2, child: Text("Planner")),
                          const PopupMenuItem(
                            value: 3,
                            child: Text("Cerrar sesión"),
                          )
                        ],
                        onSelected: (valor) async {
                          if (valor == 1) {
                            Navigator.pushNamed(context, '/perfil');
                          } else if (valor == 2) {
                            Navigator.of(context).pushNamed('/perfilPlanner');
                          } else if (valor == 3) {
                            await _sharedPreferences.clear();
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
              toolbarHeight: 150.0,
              backgroundColor: hexToColor('#fdf4e5'),
              bottom: TabBar(
                onTap: (int index) {
                  setState(
                    () {
                      _pageIndex = index;
                    },
                  );
                },
                indicatorColor: Colors.black,
                isScrollable: true,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: pantallas,
            ),
          ),
        ));
  }

  List<TabItem> obtenerTabs(ItemModelSecciones secciones) {
    List<TabItem> tabs = [];
    int temp = 0;

    if (secciones != null) {
      if (secciones.hasAcceso(claveSeccion: 'WP-CEV')) {
        tabs.add(const TabItem(titulo: 'Dashboard', icono: Icons.dashboard));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRE')) {
        tabs.add(
            const TabItem(titulo: 'Prospectos', icono: Icons.folder_shared_sharp));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-EVT')) {
        tabs.add(
            const TabItem(titulo: 'Eventos', icono: Icons.calendar_today_outlined));
        temp += 1;
      }
      // if (secciones.hasAcceso(claveSeccion: 'WP-EIN')) {
      //   tabs.add(TabItem(
      //       titulo: 'Estatus de invitaciones',
      //       icono: Icons.card_membership_rounded));
      //   temp += 1;
      // }
      if (secciones.hasAcceso(claveSeccion: 'WP-TIM')) {
        tabs.add(const TabItem(
            titulo: 'Cronogramas', icono: Icons.hourglass_bottom_rounded));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PLN')) {
        tabs.add(const TabItem(titulo: 'Plantillas', icono: Icons.copy));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-TEV')) {
        tabs.add(const TabItem(
            titulo: 'Tipos de eventos', icono: Icons.event_note_outlined));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRV')) {
        tabs.add(const TabItem(
            titulo: 'Proveedores', icono: Icons.support_agent_outlined));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-IVT')) {
        tabs.add(const TabItem(
            titulo: 'Inventario', icono: Icons.featured_play_list_outlined));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRS')) {
        tabs.add(
            const TabItem(titulo: 'Presupuesto', icono: Icons.attach_money_sharp));
        temp += 1;
      }

      if (secciones.hasAcceso(claveSeccion: 'WP-USR')) {
        tabs.add(const TabItem(titulo: 'Usuarios', icono: Icons.people));
        temp += 1;
      }
      _pages = temp;
      return tabs;
    } else {
      return [const TabItem(titulo: 'Sin permisos', icono: Icons.block)];
    }
  }

  List<Widget> obtenerPantallasSecciones(ItemModelSecciones secciones) {
    List<Widget> pan = [];
    if (secciones != null) {
      if (secciones.hasAcceso(claveSeccion: 'WP-CEV')) {
        pan.add(const DashboardCalendarPage());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRE')) {
        pan.add(const ProspectosPage());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-EVT')) {
        pan.add(DashboardEventos(
            WP_EVT_CRT:
                permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-CRT'),
            data: widget.data));
      }

      if (secciones.hasAcceso(claveSeccion: 'WP-TIM')) {
        pan.add(const Timing());
      }

      if (secciones.hasAcceso(claveSeccion: 'WP-PLN')) {
        pan.add(const Machotes());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRV')) {
        pan.add(const Proveedores());
      }

      if (secciones.hasAcceso(claveSeccion: 'WP-USR')) {
        pan.add(const Usuarios());
      }
      return pan;
    } else {
      return [
        const Center(
          child: Text('Sin permisos.'),
        )
      ];
    }
  }

  _showDialogMsg(BuildContext contextT) {
    _dialogContext = contextT;
    return AlertDialog(
      title: const Text(
        "Sesión",
        textAlign: TextAlign.center,
      ),
      content: const Text(
          'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () async {
            await _sharedPreferences.clear();
            Navigator.of(contextT)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ],
    );
  }
}
