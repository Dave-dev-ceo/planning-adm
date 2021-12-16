import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        ),
      );
      // temp.add(ResumenEvento(
      //   detalleEvento: detalleEvento,
      //   WP_EVT_RES_EDT: pantallas.hasAcceso(clavePantalla: 'WP-EVT-RES-EDT'),
      // ));
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-TIM')) {
      gridCard.add(_builCard('Actividades', PlanesPage()));
      // temp.add(PlanesPage());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-CON')) {
      gridCard.add(_builCard('Documentos', NewContrato()));

      // temp.add(NewContrato());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-LTS')) {
      gridCard.add(_builCard('Presupuestos', Pagos()));

      // temp.add(Pagos());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-PRV')) {
      gridCard.add(_builCard('Proveedores', ProveedorEvento()));

      // temp.add(ProveedorEvento());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-AUT')) {
      gridCard.add(_builCard('Autorizaciones', AutorizacionLista()));

      // temp.add(AutorizacionLista());
    }
    if (pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
      gridCard.add(_builCard(
          'Invitados',
          ListaInvitados(
            idEvento: detalleEvento.idEvento,
            WP_EVT_INV_CRT:
                pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-CRT'),
            WP_EVT_INV_EDT:
                pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-EDT'),
            WP_EVT_INV_ENV:
                pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV-ENV'),
            nameEvento: detalleEvento.descripcion,
          )));
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
      gridCard.add(_builCard('Listas', Listas()));

      // temp.add(Listas());
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

  Widget _builCard(String titulo, dynamic page) {
    return GestureDetector(
      child: Card(
        elevation: 7.0,
        child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titulo,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )),
      ),
      onTap: () {
        showDialog(context: context, builder: (context) => page);
      },
    );
  }

  Widget appBarCustom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(250.0),
      child: AppBar(
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
                Text(
                  detalleEvento.descripcion,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_outlined),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'portada.jpg',
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
                      )),
                ),
              ),
              // Positioned(
              //   top: 15.0,
              //   right: 10.0,
              //   child: Container(
              //     margin: EdgeInsets.only(right: 10.0),
              //     child: CircleAvatar(
              //       backgroundColor: hexToColor('#d39942'),
              //       child: PopupMenuButton(
              //         child: detalleEvento.img == null
              //             ? Icon(Icons.person)
              //             : CircleAvatar(
              //                 backgroundImage:
              //                     MemoryImage(base64Decode(detalleEvento.img)),
              //               ),
              //         itemBuilder: (context) => [
              //           PopupMenuItem(
              //             value: 1,
              //             child: Text("Perfil"),
              //           ),
              //           if (!isInvolucrado)
              //             PopupMenuItem(value: 2, child: Text("Planner")),
              //           PopupMenuItem(
              //             value: 3,
              //             child: Text("Cerrar sesión"),
              //           )
              //         ],
              //         onSelected: (valor) async {
              //           if (valor == 1) {
              //             Navigator.pushNamed(context, '/perfil');
              //           } else if (valor == 2) {
              //             Navigator.of(context).pushNamed('/perfilPlanner');
              //           } else if (valor == 3) {
              //             await SharedPreferencesT().clear();
              //             Navigator.pushReplacementNamed(context, '/');
              //           }
              //         },
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

// Widget fechaData() {
//   return BlocBuilder<EvtBloc.EventosBloc, EvtBloc.EventosState>(
//     builder: (context, state) {
//       if (state is EvtBloc.LoadingEventoPorIdState) {
//         return Center(child: CircularProgressIndicator());
//       } else if (state is EvtBloc.MostrarEventoPorIdState) {
//         eventoFecha = state.evento;
//         eventosBloc.add(EvtBloc.FechtEventosEvent());
//         return Container(
//             width: 400, height: 200, child: miCardContadorFecha(eventoFecha));
//       } else if (state is EvtBloc.ErrorEventoPorIdState) {
//         return Center(
//           child: Text(state.message),
//         );
//       } else {
//         if (eventoFecha != null) {
//           return Container(
//               width: 400, height: 200, child: miCardContadorFecha(eventoFecha));
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       }
//     },
//   );
// }

  // miCardContadorFecha(ItemModelEvento evento) {
  //   String fechaEvento = evento.results.elementAt(0).fechaEvento;

  //   bool isActive = false;

  //   Duration fechaEventoTime =
  //       DateTime.now().difference(DateTime.parse(fechaEvento));

  //   // if (fechaEventoTime.inSeconds.isNegative) {
  //   //   isActive = true;
  //   //   if (mounted) {
  //   //     _timer = Timer(Duration(seconds: 1), () {
  //   //       if (mounted) {
  //   //         setState(() {
  //   //           fechaEventoTime =
  //   //               DateTime.parse(fechaEvento).difference(DateTime.now());
  //   //         });
  //   //       }
  //   //     });
  //   //   } else {
  //   //     _timer.cancel();
  //   //   }
  //   // }

  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     margin: EdgeInsets.all(20.0),
  //     elevation: 10,
  //     child: Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: ListTile(
  //         leading: Icon(Icons.access_time_filled_outlined),
  //         title: Column(
  //           children: [
  //             Text(
  //               'Fecha restante:',
  //               style: Theme.of(context).textTheme.subtitle1,
  //             ),
  //             RichText(
  //                 text: TextSpan(
  //               style: TextStyle(fontSize: 18.0, color: Colors.black),
  //               text: isActive
  //                   ? '${_printDuration(fechaEventoTime)}'
  //                   : 'Evento finalzado',
  //             )),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // String _printDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String twoDigitHours = twoDigits(duration.inHours.remainder(24) * -1);
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60) * -1);
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60) * -1);
  //   return "Dias: ${duration.inDays * -1}, Horas: $twoDigitHours, Minutos: $twoDigitMinutes, Segundos: $twoDigitSeconds";
  // }