// ignore_for_file: no_logic_in_create_state

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
  final Map<dynamic, dynamic>? detalleEvento;
  const Invitados({Key? key, this.detalleEvento}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState(detalleEvento);
}

class _InvitadosState extends State<Invitados> with TickerProviderStateMixin {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  final Map<dynamic, dynamic>? detalleEvento;
  int _pages = 0;
  PermisosBloc? permisosBloc;
  late ItemModelPerfil permisoPantallas;
  bool isInvolucrado = false;
  TabController? _tabController;
  bool _tapped = false;
  late Size size;
  String? claveRol;
  bool? desconectado = false;

  _InvitadosState(this.detalleEvento);
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    permisosBloc = BlocProvider.of<PermisosBloc>(context);
    // permisosBloc.add(ObtenerPermisosEvent());
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
    return FutureBuilder(
        future: SharedPreferencesT().getModoConexion(),
        builder: (context, snapshot) {
          if (!(snapshot.hasData)) {
            return const Center(child: CircularProgressIndicator());
          }
          desconectado = snapshot.data as bool;
          return SizedBox(
            width: double.infinity,
            child: BlocBuilder<PermisosBloc, PermisosState>(
              builder: (context, state) {
                if (state is PermisosInitial) {
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                    ),
                    body: const Center(child: LoadingCustom()),
                  );
                } else if (state is ErrorTokenPermisos) {
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                    ),
                    body: const Center(child: LoadingCustom()),
                  );
                } else if (state is LoadingPermisos) {
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                    ),
                    body: const Center(child: LoadingCustom()),
                  );
                } else if (state is PermisosOk) {
                  permisoPantallas = state.permisos;
                  List<TabItem> tabs = obtenerTabsPantallas(state.permisos
                      .pantallas); /* <TabItem>[TabItem(titulo: 'test', icono: Icons.ac_unit)]; */
                  List<Widget> pantallas = obtenerPantallasContent(state
                      .permisos
                      .pantallas); /* <Widget>[Center(child: Text('Test'))]; */
                  // Navigator.pop(_dialogContext);

                  _tabController = TabController(length: _pages, vsync: this);

                  _tabController!.addListener(() {
                    if (((!desconectado! && _tabController!.index == 5) ||
                            (desconectado! && _tabController!.index == 2)) &&
                        ((!_tapped && !_tabController!.indexIsChanging) ||
                            _tabController!.indexIsChanging)) {
                      showDialog(
                          context: context,
                          builder: (context) => ListaInvitados(
                                idEvento: detalleEvento!['idEvento'],
                                WP_EVT_INV_CRT: permisoPantallas.pantallas
                                    .hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
                                WP_EVT_INV_EDT: permisoPantallas.pantallas
                                    .hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
                                WP_EVT_INV_ENV: permisoPantallas.pantallas
                                    .hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
                                nameEvento: widget.detalleEvento!['nEvento'],
                                permisos: state.permisos,
                              )).then((_) => _tabController!.index =
                          _tabController!.previousIndex);
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
                      idEvento: detalleEvento!['idEvento'],
                      WP_EVT_INV_CRT: permisoPantallas.pantallas
                          .hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
                      WP_EVT_INV_EDT: permisoPantallas.pantallas
                          .hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
                      WP_EVT_INV_ENV: permisoPantallas.pantallas
                          .hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
                      nameEvento: widget.detalleEvento!['nEvento'],
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
                  return const Center(child: Text('Sin permisos'));
                }
              },
            ),
          );
        });
  }

  Widget crearPantallas(BuildContext context, List<TabItem> pantallasTabs,
      List<Widget> pantallasCOntent) {
    return Scaffold(
      appBar: AppBar(
        leading: (!isInvolucrado)
            ? (size.width > 500)
                ? IconButton(
                    tooltip: 'Inicio',
                    icon: const Icon(Icons.home),
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
                          'assets/logo.png',
                          height: 100.0,
                          width: 200.0,
                        ),
                      ),
                    ),
                  )
            : null,
        automaticallyImplyLeading: widget.detalleEvento!['boton'],
        title: Center(
          child: (size.width > 500)
              ? Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const Text(
                              'CONFIGURACIÓN EVENTO',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            Text(
                              '${widget.detalleEvento!['nEvento']}',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                            child: Image.asset(
                          'assets/logo.png',
                          height: 100.0,
                          width: 250.0,
                        )),
                      ),
                    ),
                    const Spacer(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'CONFIGURACIÓN EVENTO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                    AutoSizeText(
                      '${widget.detalleEvento!['nEvento']}',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      // '${widget.detalleEvento['nEvento']}',
                      style: const TextStyle(fontSize: 10.0),
                    ),
                  ],
                ),
        ),
        toolbarHeight: (size.width > 500) ? 150.0 : 80,
        backgroundColor: hexToColor('#fdf4e5'),
        actions: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: PopupMenuButton(
                  child: widget.detalleEvento!['imag'] == null ||
                          widget.detalleEvento!['imag'] == ''
                      ? const FaIcon(
                          FontAwesomeIcons.user,
                          color: Colors.black,
                        )
                      : CircleAvatar(
                          backgroundImage: MemoryImage(
                              base64Decode(widget.detalleEvento!['imag'])),
                        ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Perfil"),
                    ),
                    if (claveRol == 'SU')
                      const PopupMenuItem(value: 2, child: Text("Planner")),
                    const PopupMenuItem(
                      value: 3,
                      child: Text("Cerrar sesión"),
                    )
                  ],
                  onSelected: (dynamic valor) async {
                    if (valor == 1) {
                      Navigator.pushNamed(context, '/perfil');
                    } else if (valor == 2) {
                      Navigator.of(context).pushNamed('/perfilPlanner');
                    } else if (valor == 3) {
                      dialogoCerrarSesion();
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
        children: pantallasCOntent,
        controller: _tabController,
      ),
    );
  }

  void dialogoCerrarSesion() async {
    bool offline = await _sharedPreferences.getModoConexion();
    if (!offline) {
      await _sharedPreferences.clear();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Modo sin conexión detectado',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: 350,
              child: Text(
                'Desactive el modo sin conexión para subir sus cambios antes de cerrar sesión.',
                textAlign: TextAlign.justify,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  List<TabItem> obtenerTabsPantallas(ItemModelPantallas pantallas) {
    List<TabItem> tabs = [];
    int temp = 0;
    if (pantallas != null) {
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES')!) {
        tabs.add(const TabItem(titulo: 'Resumen', icono: Icons.list));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')! && !desconectado!) {
        tabs.add(const TabItem(
            titulo: 'Actividades', icono: Icons.access_time_sharp));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')!) {
        tabs.add(const TabItem(
            titulo: 'Documentos', icono: Icons.description_outlined));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-PLN-PAG')! && !desconectado!) {
        tabs.add(
            const TabItem(titulo: 'Presupuestos', icono: Icons.credit_card));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')! && !desconectado!) {
        tabs.add(const TabItem(
            titulo: 'Proveedores', icono: Icons.support_agent_outlined));
        temp += 1;
      }
      //if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-AUT')) {
      //  tabs.add(TabItem(titulo: 'Autorizaciones', icono: Icons.brush));
      //  temp += 1;
      //}
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')! ||
          pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI')! ||
          pantallas.hasAcceso(clavePantalla: 'WP-EVT-MDE')!) {
        tabs.add(const TabItem(titulo: 'Invitados', icono: Icons.people));
        temp += 1;
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-IVT')! && !desconectado!) {
        tabs.add(const TabItem(
            titulo: 'Inventario', icono: Icons.featured_play_list_outlined));
        temp += 1;
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRS')! && !desconectado!) {
        tabs.add(const TabItem(
            titulo: 'Presupuesto', icono: Icons.attach_money_sharp));
        temp += 1;
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')! && !desconectado!) {
        tabs.add(const TabItem(titulo: 'Listas', icono: Icons.list));
        temp += 1;
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP_BOK_INS')! && !desconectado!) {
        tabs.add(const TabItem(
            titulo: 'Book Inspiration', icono: Icons.edit_road_sharp));
        temp += 1;
      }

      _pages = temp;
      return tabs;
    } else {
      _pages += 1;
      return [const TabItem(titulo: 'Sin permisos', icono: Icons.block)];
    }
  }

  List<Widget> obtenerPantallasContent(ItemModelPantallas pantallas) {
    List<Widget> temp = [];
    if (pantallas != null) {
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES')!) {
        temp.add(ResumenEvento(
          detalleEvento: detalleEvento,
          WP_EVT_RES_EDT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES-EDT'),
        ));
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')! && !desconectado!) {
        temp.add(const PlanesPage());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')!) {
        temp.add(const NewContrato());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-PLN-PAG')! && !desconectado!) {
        temp.add(const Pagos());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')! && !desconectado!) {
        temp.add(const ProveedorEvento());
      }
      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')!) {
        temp.add(const Center(
          child: LoadingCustom(),
        ));
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')! && !desconectado!) {
        temp.add(const Listas());
      }

      if (pantallas.hasAcceso(clavePantalla: 'WP_BOK_INS')! && !desconectado!) {
        temp.add(const BookInspiracion());
      }

      return temp;
    } else {
      return [
        const Center(
          child: Text('Sin permisos.'),
        )
      ];
    }
  }
}
