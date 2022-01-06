import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:planning/src/blocs/permisos/permisos_bloc.dart';
import 'package:planning/src/models/eventoModel/evento_resumen_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/ui/Listas/listas.dart';
import 'package:planning/src/ui/Resumen/resumen_evento.dart';
import 'package:planning/src/ui/autorizacion/lista_autorizacion.dart';
import 'package:planning/src/ui/contratos/new_contrato.dart';
import 'package:planning/src/ui/pagos/pagos.dart';
import 'package:planning/src/ui/planes/planes.dart';
import 'package:planning/src/ui/proveedores_evento/proveedores_evento.dart';
import 'package:planning/src/ui/widgets/invitados/lista_invitados.dart';

class DashboardInvolucradoPage extends StatefulWidget {
  final EventoResumenModel detalleEvento;

  const DashboardInvolucradoPage({Key key, this.detalleEvento})
      : super(key: key);

  @override
  _DashboardInvolucradoPageState createState() =>
      _DashboardInvolucradoPageState(detalleEvento);
}

class _DashboardInvolucradoPageState extends State<DashboardInvolucradoPage> {
  final EventoResumenModel detalleEvento;

  PermisosBloc permisosBloc;
  bool isInvolucrado = false;

  _DashboardInvolucradoPageState(this.detalleEvento);

  void initState() {
    permisosBloc = BlocProvider.of<PermisosBloc>(context);
    permisosBloc.add(obtenerPermisosEvent());

    getIdInvolucrado();
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  getIdInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: BlocBuilder<PermisosBloc, PermisosState>(
        builder: (context, state) {
          if (state is PermisosInitial) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ErrorTokenPermisos) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is LoadingPermisos) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is PermisosOk) {
            return Scaffold(
              appBar: appBarCustom(),
              body: gridDasboarBody(state.permisos.pantallas),
            );
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

  Widget gridDasboarBody(ItemModelPantallas pantallas) {
    List<Widget> gridCard = [];

    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES')) {
      gridCard.add(
        _builCard(
            'Resumen',
            ResumenEvento(
              detalleEvento: {
                'idEvento': detalleEvento.idEvento,
                'nEvento': detalleEvento.descripcion,
                'nombre': detalleEvento.nombreCompleto,
                'boton': false,
                'imag': detalleEvento.img
              },
              WP_EVT_RES_EDT:
                  pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES-EDT'),
            ),
            FaIcon(FontAwesomeIcons.clipboardList)),
      );
      // temp.add(ResumenEvento(
      //   detalleEvento: detalleEvento,
      //   WP_EVT_RES_EDT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES-EDT'),
      // ));
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')) {
      gridCard.add(
        _builCard('Actividades', PlanesPage(),
            FaIcon(FontAwesomeIcons.solidCalendarCheck)),
      );
      // temp.add(PlanesPage());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')) {
      gridCard.add(_builCard(
        'Documentos',
        NewContrato(),
        FaIcon(FontAwesomeIcons.book),
      ));

      // temp.add(NewContrato());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')) {
      gridCard.add(_builCard(
        'Presupuestos',
        Pagos(),
        FaIcon(FontAwesomeIcons.moneyBillWave),
      ));

      // temp.add(Pagos());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')) {
      gridCard.add(_builCard(
        'Proveedores',
        ProveedorEvento(),
        FaIcon(FontAwesomeIcons.peopleCarry),
      ));

      // temp.add(ProveedorEvento());
    }
    // if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-AUT')) {
    //   gridCard.add(_builCard(
    //     'Autorizaciones',
    //     AutorizacionLista(),
    //     FaIcon(FontAwesomeIcons.moneyCheck),
    //   ));
    //   // temp.add(AutorizacionLista());
    // }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
      gridCard.add(_builCard(
        'Invitados',
        ListaInvitados(
          idEvento: detalleEvento.idEvento,
          WP_EVT_INV_CRT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
          WP_EVT_INV_EDT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
          WP_EVT_INV_ENV: pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
          nameEvento: detalleEvento.descripcion,
        ),
        FaIcon(FontAwesomeIcons.users),
      ));
      // temp.add(ListaInvitados(
      // idEvento: detalleEvento['idEvento'],
      // WP_EVT_INV_CRT:
      // pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
      // WP_EVT_INV_EDT:
      // pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
      // WP_EVT_INV_ENV:
      // pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
      // nameEvento: widget.detalleEvento['nEvento']));
    }

    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')) {
      gridCard.add(_builCard(
        'Listas',
        Listas(),
        FaIcon(FontAwesomeIcons.thList),
      ));

      // temp.add(Listas());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 10.0,
      ),
      child: GridView.builder(
        itemCount: gridCard.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          mainAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (BuildContext context, int index) {
          return gridCard[index];
        },
      ),
    );
  }

  Widget _builCard(String titulo, dynamic page, Widget icon) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            )),
        elevation: 7.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                stops: [
                  0.10,
                  0.52,
                  0.90,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFf4e4d2),
                  Color(0xFFfdf6e8),
                  Color(0xFFf7e5d4),
                ],
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  titulo,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showDialog(context: context, builder: (context) => page);
      },
    );
  }

  Widget appBarCustom() {
    final IconThemeData iconTheme = IconTheme.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(200.0),
      child: AppBar(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Perfil"),
              ),
              if (!isInvolucrado)
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
                await SharedPreferencesT().clear();
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    // Text(
                    //   detalleEvento.descripcion,
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     foreground: Paint()
                    //       ..style = PaintingStyle.stroke
                    //       ..strokeWidth = 7
                    //       ..color = Colors.white,
                    //   ),
                    // ),
                    Text(
                      detalleEvento.descripcion,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oleo',
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: iconTheme.size + 4,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (detalleEvento.portada == null ||
                              detalleEvento.portada == '')
                          ? AssetImage(
                              'portada.jpg',
                            )
                          : MemoryImage(
                              base64Decode(detalleEvento.portada),
                            ),
                    )),
                width: double.infinity,
                height: 200,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 60,
                      height: 80,
                      child: Image.asset(
                        'assets/new_logo.png',
                        fit: BoxFit.contain,
                        color: Color(0xFFfdf4e5),
                      )),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: ContadorEventoPage(
                  fechaEvento: detalleEvento.fechaEvento,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContadorEventoPage extends StatefulWidget {
  final DateTime fechaEvento;

  const ContadorEventoPage({Key key, @required this.fechaEvento})
      : super(key: key);

  @override
  _ContadorEventoPageState createState() =>
      _ContadorEventoPageState(fechaEvento);
}

class _ContadorEventoPageState extends State<ContadorEventoPage> {
  final DateTime fechaEvento;
  Timer timer;
  Duration fechaEventoTime;
  bool isActive = false;

  double turns = 0.0;

  _ContadorEventoPageState(this.fechaEvento);

  @override
  void initState() {
    fechaEventoTime = DateTime.now()
        .difference(DateTime.parse(widget.fechaEvento.toString()));

    if (widget.fechaEvento.isAfter(DateTime.now().toLocal())) {
      setState(() {
        isActive = true;
      });
    }
    initTimer();
    super.initState();
  }

  initTimer() async {
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      setState(() {
        fechaEventoTime = DateTime.parse(widget.fechaEvento.toString())
            .difference(DateTime.now());

        if (widget.fechaEvento.isBefore(DateTime.now().toLocal())) {
          isActive = false;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (isActive)
            Text(
              'Tiempo restante:',
              style: TextStyle(color: Colors.white),
            ),
          if (!isActive)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'El evento ya finalizó',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            timerEvento()
        ],
      ),
    );
  }

  Widget timerEvento() {
    return Row(
      children: [
        cardTime(dayRest(fechaEventoTime), 'Días'),
        cardTime(twoDigitsHours(fechaEventoTime), 'Horas'),
        cardTime(twoDigitMinutes(fechaEventoTime), 'Minutos'),
      ],
    );
  }

  Widget cardTime(String time, String tipoTime) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(tipoTime)
          ],
        ),
      ),
    );
  }

  String twoDigitsHours(Duration duration) {
    return twoDigits(duration.inHours.isNegative
        ? duration.inHours.remainder(24) * -1
        : duration.inHours.remainder(24) * 1);
  }

  String twoDigitMinutes(Duration duration) {
    return twoDigits(duration.inMinutes.isNegative
        ? duration.inMinutes.remainder(60) * -1
        : duration.inMinutes.remainder(60) * 1);
  }

  String twoDigitSeconds(Duration duration) {
    return twoDigits(duration.inSeconds.remainder(60) * 1);
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String dayRest(Duration duration) {
    if (duration.inDays >= 0 && duration.inDays <= 9) {
      return "0${duration.inDays.isNegative ? duration.inDays * -1 : duration.inDays * 1}";
    } else {
      return "${duration.inDays.isNegative ? duration.inDays * -1 : duration.inDays * 1}";
    }
  }
}
