import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/permisos/permisos_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/ui/Resumen/resumen_evento.dart';
import 'package:planning/src/ui/Listas/listas.dart';
import 'package:planning/src/ui/book_inspiracion/book_inspiracion.dart';
import 'package:planning/src/ui/contratos/new_contrato.dart';
import 'package:planning/src/ui/pagos/pagos.dart';
import 'package:planning/src/ui/planes/planes.dart';
import 'package:planning/src/ui/proveedores_evento/proveedores_evento.dart';
import 'package:planning/src/ui/widgets/invitados/lista_invitados.dart';
import 'package:planning/src/ui/widgets/tab/tab_item.dart';

class Invitados extends StatefulWidget {
  //static const routeName = '/eventos';
  final Map<dynamic, dynamic> detalleEvento;
  const Invitados({Key key, this.detalleEvento}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState(detalleEvento);
}

class _InvitadosState extends State<Invitados> with TickerProviderStateMixin {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final Map<dynamic, dynamic> detalleEvento;
  int _pages = 0;
  PermisosBloc permisosBloc;
  ItemModelPerfil permisoPantallas;
  bool isInvolucrado = false;
  TabController _tabController;
  bool _tapped = false;
  Size size;
  String claveRol;

  _InvitadosState(this.detalleEvento);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void initState() {
    permisosBloc = BlocProvider.of<PermisosBloc>(context);
    permisosBloc.add(obtenerPermisosEvent());
    getClaveRol();

    getIdInvolucrado();

    super.initState();
  }

  getClaveRol() async {
    claveRol = await _sharedPreferences.getClaveRol();
  }

  getIdInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      child: BlocBuilder<PermisosBloc, PermisosState>(
        builder: (context, state) {
          if (state is PermisosInitial) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(child: LoadingCustom()),
            );
          } else if (state is ErrorTokenPermisos) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(child: LoadingCustom()),
            );
          } else if (state is LoadingPermisos) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(child: LoadingCustom()),
            );
          } else if (state is PermisosOk) {
            permisoPantallas = state.permisos;
            List<TabItem> tabs = obtenerTabsPantallas(state.permisos
                .pantallas); /* <TabItem>[TabItem(titulo: 'test', icono: Icons.ac_unit)]; */
            List<Widget> pantallas = obtenerPantallasContent(state.permisos
                .pantallas); /* <Widget>[Center(child: Text('Test'))]; */
            // Navigator.pop(_dialogContext);

            _tabController = TabController(length: _pages, vsync: this);

            _tabController.addListener(() {
              if (_tabController.index == 5 &&
                  ((!_tapped && !_tabController.indexIsChanging) ||
                      _tabController.indexIsChanging)) {
                showDialog(
                    context: context,
                    builder: (context) => ListaInvitados(
                          idEvento: detalleEvento['idEvento'],
                          WP_EVT_INV_CRT: permisoPantallas.pantallas
                              .hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
                          WP_EVT_INV_EDT: permisoPantallas.pantallas
                              .hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
                          WP_EVT_INV_ENV: permisoPantallas.pantallas
                              .hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
                          nameEvento: widget.detalleEvento['nEvento'],
                          permisos: state.permisos,
                        )).then(
                    (_) => _tabController.index = _tabController.previousIndex);
              }
              _tapped = false;
            });

            int bandera = 0;

            for (var pantallla in state.permisos.pantallas.secciones) {
              if ((pantallla.clavePantalla == 'WP-EVT-ASI' &&
                      pantallla.acceso == true) ||
                  (pantallla.clavePantalla == 'WP-EVT-INV' &&
                      pantallla.acceso == true) ||
                  (pantallla.clavePantalla == 'WP-EVT-MDE' &&
                      pantallla.acceso == true)) {
                bandera += 1;
              }
            }
            if (bandera <= 3 && bandera != 0) {
              return ListaInvitados(
                idEvento: detalleEvento['idEvento'],
                WP_EVT_INV_CRT: permisoPantallas.pantallas
                    .hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
                WP_EVT_INV_EDT: permisoPantallas.pantallas
                    .hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
                WP_EVT_INV_ENV: permisoPantallas.pantallas
                    .hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
                nameEvento: widget.detalleEvento['nEvento'],
                permisos: state.permisos,
              );
            } else {
              return crearPantallas(context, tabs, pantallas);
            }
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
    return Scaffold(
      appBar: AppBar(
        leading: (!isInvolucrado)
            ? (size.width > 500)
                ? IconButton(
                    tooltip: 'Inicio',
                    icon: Icon(Icons.home),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Tooltip(
                      message: 'Inicio',
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/new_logo.png',
                          height: 100.0,
                          width: 250.0,
                        ),
                      ),
                    ),
                  )
            : null,
        automaticallyImplyLeading: widget.detalleEvento['boton'],
        title: Center(
          child: (size.width > 500)
              ? Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Text(
                              'CONFIGURACIÓN EVENTO',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            Text(
                              '${widget.detalleEvento['nEvento']}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                            child: Image.asset(
                          'assets/new_logo.png',
                          height: 100.0,
                          width: 250.0,
                        )),
                      ),
                    ),
                    Spacer(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'CONFIGURACIÓN EVENTO',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                    AutoSizeText(
                      '${widget.detalleEvento['nEvento']}',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      // '${widget.detalleEvento['nEvento']}',
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ],
                ),
        ),
        toolbarHeight: (size.width > 500) ? 150.0 : 80,
        backgroundColor: hexToColor('#fdf4e5'),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundColor: hexToColor('#d39942'),
                child: PopupMenuButton(
                  child: widget.detalleEvento['imag'] == null ||
                          widget.detalleEvento['imag'] == ''
                      ? FaIcon(
                          FontAwesomeIcons.user,
                          color: Colors.black,
                        )
                      : CircleAvatar(
                          backgroundImage: MemoryImage(
                              base64Decode(widget.detalleEvento['imag'])),
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
              ))
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (int index) {
            _tapped = true;
          },
          indicatorColor: Colors.black,
          isScrollable: true,
          tabs: pantallasTabs,
        ),
      ),
      body: TabBarView(
        children: PantallasCOntent,
        controller: _tabController,
      ),
    );
  }

  List<TabItem> obtenerTabsPantallas(ItemModelPantallas pantallas) {
    List<TabItem> tabs = [];
    int temp = 0;
    if (pantallas != null) {
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES')) {
        tabs.add(TabItem(titulo: 'Resumen', icono: Icons.list));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')) {
        tabs.add(
            TabItem(titulo: 'Actividades', icono: Icons.access_time_sharp));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')) {
        tabs.add(
            TabItem(titulo: 'Documentos', icono: Icons.description_outlined));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-PLN-PAG')) {
        tabs.add(TabItem(titulo: 'Presupuestos', icono: Icons.credit_card));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')) {
        tabs.add(TabItem(
            titulo: 'Proveedores', icono: Icons.support_agent_outlined));
        temp += 1;
      }
      //if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-AUT')) {
      //  tabs.add(TabItem(titulo: 'Autorizaciones', icono: Icons.brush));
      //  temp += 1;
      //}
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV') ||
          pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI') ||
          pantallas.hasAcceso(clavePantalla: 'WP-EVT-MDE')) {
        tabs.add(TabItem(titulo: 'Invitados', icono: Icons.people));
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

      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')) {
        tabs.add(TabItem(titulo: 'Listas', icono: Icons.list));
        temp += 1;
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP_BOK_INS')) {
        tabs.add(
            TabItem(titulo: 'Book Inspiration', icono: Icons.edit_road_sharp));
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
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')) {
        temp.add(PlanesPage());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')) {
        temp.add(NewContrato());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-PLN-PAG')) {
        temp.add(Pagos());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')) {
        temp.add(ProveedorEvento());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
        temp.add(Center(
          child: LoadingCustom(),
        ));
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')) {
        temp.add(Listas());
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP_BOK_INS')) {
        temp.add(BookInspiracion());
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
