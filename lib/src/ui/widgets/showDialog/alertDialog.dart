// ignore_for_file: missing_return

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/asistencia/asistencia_bloc.dart';
import 'package:planning/src/blocs/qr_invitado/qr_bloc.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class DialogAlert extends StatefulWidget {
  final String dataInfo;

  const DialogAlert({Key key, @required this.dataInfo}) : super(key: key);

  @override
  _DialogAlertState createState() => _DialogAlertState(dataInfo: dataInfo);
}

class _DialogAlertState extends State<DialogAlert> {
  final String dataInfo;
  _DialogAlertState({@required this.dataInfo});

  List<String> lista = [];
  QrBloc qrBloc;
  String nombreInvitado;
  String eventoDescripcion;

  @override
  void initState() {
    qrBloc = BlocProvider.of<QrBloc>(context);
    qrBloc.add(QrValidation(dataInfo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<QrBloc, QrState>(
        listener: (context, state) {
          if (state is QrValidAnotherState) {
            Navigator.of(context).pop();
            MostrarAlerta(
                mensaje: 'El codigo Qr no es valido',
                tipoMensaje: TipoMensaje.error);
          } else if (state is QrErrorState) {
            Navigator.of(context).pop();
            MostrarAlerta(
                mensaje: 'Ocurrio un error al leer el QR',
                tipoMensaje: TipoMensaje.error);
          }
        },
        child: BlocBuilder<QrBloc, QrState>(
          builder: (context, state) {
            if (state is QrValidState) {
              final invitado = state.qrData;
              nombreInvitado = invitado.nombre;
              eventoDescripcion = invitado.evento;
              return AlertDialog(
                scrollable: false,
                title: Center(child: Text('Datos de invitado')),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      texto('Evento: ', invitado.evento, 'Sin evento asignado'),
                      texto('Invitado: ', invitado.nombre, 'Sin nombre'),
                      texto('Grupo: ', invitado.grupo, 'Sin nombre'),
                      texto('Mesa: ', invitado.mesa, 'Sin mesa'),
                      texto('Correo: ', invitado.correo, 'Sin correo'),
                      texto('Teléfono: ', invitado.telefono, 'Sin teléfono'),
                      if (invitado.acompanantes.length > 0)
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Acompañantes:'),
                        ),
                      for (var acompanante in invitado.acompanantes)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(acompanante.nombre),
                        )
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 5,
                          child: TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancelar'))),
                      Expanded(
                          flex: 5,
                          child: TextButton(
                              onPressed: () => {
                                    _guardarAsistencia(invitado.idInvitado,
                                        invitado.nombre, true, invitado.evento),
                                  },
                              child: Text('Aceptar'))),
                    ],
                  )
                ],
              );
            } else if (state is QrInvitadoUpdateState) {
              return AlertDialog(
                title: Text('¡Bienvenido!'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '$nombreInvitado estás en el evento $eventoDescripcion'),
                    Text('Gracias por asistir.'),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Ok')),
                ],
              );
            } else {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: LoadingCustom(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget texto(String label, String valor, String sinDatos) {
    return Padding(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label + (valor != null ? valor : sinDatos),
        ),
      ),
      padding: EdgeInsets.all(10),
    );
  }

  _guardarAsistencia(int idInvitado, String nombre, bool asistenciaValor,
      String evento) async {
    // BlocProvider - cargamos el evento
    AsistenciaBloc asistenciaBloc;
    asistenciaBloc = BlocProvider.of<AsistenciaBloc>(context);
    await asistenciaBloc.add(SaveAsistenciaEvent(idInvitado, asistenciaValor));
    qrBloc.add(QrInvitadoUpdateEvent());
  }
}
