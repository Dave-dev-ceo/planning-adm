// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/permisos/permisos_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/ui/construccion/construccion.dart';
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

class _HomeState extends State<Home> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  int _pageIndex = 0;
  int _pages = 0;
  PermisosBloc permisosBloc;
  BuildContext _dialogContext;
  String claveRol;

  ItemModelPerfil permisos;

  void initState() {
    permisosBloc = BlocProvider.of<PermisosBloc>(context);
    permisosBloc.add(obtenerPermisosEvent());
    getClaveRol();
    super.initState();
  }

  getClaveRol() async {
    claveRol = await _sharedPreferences.getClaveRol();
  }

  //_HomeState(this.idPlanner);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: BlocBuilder<PermisosBloc, PermisosState>(
        builder: (context, state) {
          if (state is PermisosInitial) {
            return Center(
              child: LoadingCustom(),
            );
          } else if (state is ErrorTokenPermisos) {
            return _showDialogMsg(context);
          } else if (state is LoadingPermisos) {
            return Center(child: LoadingCustom());
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
            return Center(child: Text('Sin permisos'));
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
              leading: Container(
                  child: Center(
                child: Text('PLANNER',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              )),
              leadingWidth: 100.0,
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: PopupMenuButton(
                        child: widget.data['imag'] == null ||
                                widget.data['imag'] == ''
                            ? FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              )
                            : CircleAvatar(
                                backgroundImage: MemoryImage(
                                  base64Decode(widget.data['imag']),
                                ),
                              ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text("Perfil"),
                          ),
                          if (claveRol == 'SU')
                            PopupMenuItem(value: 2, child: Text("Planner")),
                          PopupMenuItem(
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
        tabs.add(TabItem(titulo: 'Dashboard', icono: Icons.dashboard));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRE')) {
        tabs.add(
            TabItem(titulo: 'Prospectos', icono: Icons.folder_shared_sharp));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-EVT')) {
        tabs.add(
            TabItem(titulo: 'Eventos', icono: Icons.calendar_today_outlined));
        temp += 1;
      }
      // if (secciones.hasAcceso(claveSeccion: 'WP-EIN')) {
      //   tabs.add(TabItem(
      //       titulo: 'Estatus de invitaciones',
      //       icono: Icons.card_membership_rounded));
      //   temp += 1;
      // }
      if (secciones.hasAcceso(claveSeccion: 'WP-TIM')) {
        tabs.add(TabItem(
            titulo: 'Cronogramas', icono: Icons.hourglass_bottom_rounded));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PLN')) {
        tabs.add(TabItem(titulo: 'Plantillas', icono: Icons.copy));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-TEV')) {
        tabs.add(TabItem(
            titulo: 'Tipos de eventos', icono: Icons.event_note_outlined));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRV')) {
        tabs.add(TabItem(
            titulo: 'Proveedores', icono: Icons.support_agent_outlined));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-IVT')) {
        tabs.add(TabItem(
            titulo: 'Inventario', icono: Icons.featured_play_list_outlined));
        temp += 1;
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRS')) {
        tabs.add(
            TabItem(titulo: 'Presupuesto', icono: Icons.attach_money_sharp));
        temp += 1;
      }

      if (secciones.hasAcceso(claveSeccion: 'WP-USR')) {
        tabs.add(TabItem(titulo: 'Usuarios', icono: Icons.people));
        temp += 1;
      }
      _pages = temp;
      return tabs;
    } else {
      return [TabItem(titulo: 'Sin permisos', icono: Icons.block)];
    }
  }

  List<Widget> obtenerPantallasSecciones(ItemModelSecciones secciones) {
    List<Widget> pan = [];
    if (secciones != null) {
      if (secciones.hasAcceso(claveSeccion: 'WP-CEV')) {
        pan.add(DashboardCalendarPage());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRE')) {
        pan.add(ProspectosPage());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-EVT')) {
        pan.add(DashboardEventos(
            WP_EVT_CRT:
                permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-CRT'),
            data: widget.data));
      }
      // if (secciones.hasAcceso(claveSeccion: 'WP-EIN')) {
      //   pan.add(ListaEstatusInvitaciones());
      // }
      if (secciones.hasAcceso(claveSeccion: 'WP-TIM')) {
        pan.add(Timing());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-TEV')) {
        pan.add(Construccion());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PLN')) {
        pan.add(Machotes());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRV')) {
        pan.add(Proveedores());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-IVT')) {
        pan.add(Construccion());
      }
      if (secciones.hasAcceso(claveSeccion: 'WP-PRS')) {
        pan.add(Construccion());
      }

      if (secciones.hasAcceso(claveSeccion: 'WP-USR')) {
        pan.add(Usuarios());
      }
      return pan;
    } else {
      return [
        Center(
          child: Text('Sin permisos.'),
        )
      ];
    }
  }

  // _dialogSpinner(String title) {
  //   Widget child = LoadingCustom();
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         _dialogContext = context;
  //         return AlertDialog(
  //           title: Text(
  //             title,
  //             textAlign: TextAlign.center,
  //           ),
  //           content: child,
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //         );
  //       });
  // }

  _showDialogMsg(BuildContext contextT) {
    _dialogContext = contextT;
    return AlertDialog(
      title: Text(
        "Sesión",
        textAlign: TextAlign.center,
      ),
      content: Text(
          'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar'),
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
