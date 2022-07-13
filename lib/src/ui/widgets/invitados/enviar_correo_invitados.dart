import 'package:flutter/material.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

import '../../../animations/loading_animation.dart';

class EnviarCorreoInvitados extends StatefulWidget {
  const EnviarCorreoInvitados(this.invitados, {Key key}) : super(key: key);
  final List<dynamic> invitados;

  @override
  State<EnviarCorreoInvitados> createState() => _EnviarCorreoInvitadosState();
}

class _EnviarCorreoInvitadosState extends State<EnviarCorreoInvitados> {
  bool enviarATodos = false;
  final TextStyle estiloTxt = const TextStyle(fontWeight: FontWeight.bold);
  List<_InvitadoCorreo> invitados = [];
  BuildContext _dialogContext;
  ApiProvider api = ApiProvider();

  @override
  void initState() {
    initInvitados();
    super.initState();
  }

  initInvitados() {
    for (int i = 0; i < widget.invitados.length; i++) {
      invitados.add(_InvitadoCorreo(widget.invitados[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 550,
          minWidth: 650,
          maxWidth: 650,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Enviar correo con QR a invitados',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: tablaCorreos(),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_totalSeleccionados() > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        _enviarCorreos();
                      },
                      child: Icon(Icons.send),
                      tooltip: 'Enviar correos',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tablaCorreos() {
    return DataTable(
      columns: [
        DataColumn(
          label: Checkbox(
            value: enviarATodos,
            onChanged: (val) {
              setState(() {
                enviarATodos = val;
                _seleccionarTodos(val);
              });
            },
          ),
        ),
        DataColumn(label: Text('Nombre', style: estiloTxt)),
        DataColumn(label: Text('Correo', style: estiloTxt)),
      ],
      rows: [
        for (int i = 0; i < invitados.length; i++)
          DataRow(
            cells: [
              DataCell(
                Checkbox(
                  value: invitados[i].seleccionado,
                  onChanged:
                      invitados[i].correo != null && invitados[i].correo != ''
                          ? (val) {
                              setState(() {
                                if (invitados[i].seleccionado && enviarATodos) {
                                  enviarATodos = false;
                                }
                                invitados[i].seleccionado = val;
                              });
                            }
                          : null,
                ),
              ),
              DataCell(
                invitados[i].nombre != null
                    ? Text(invitados[i].nombre)
                    : Text(
                        '[Sin nombre]',
                        style: TextStyle(color: Colors.grey),
                      ),
              ),
              DataCell(
                invitados[i].correo != null && invitados[i].correo != ''
                    ? Text(invitados[i].correo)
                    : Text(
                        '[Sin correo]',
                        style: TextStyle(color: Colors.grey),
                      ),
              ),
            ],
          ),
      ],
    );
  }

  _seleccionarTodos(bool val) {
    for (int i = 0; i < invitados.length; i++) {
      if (invitados[i].correo != null && invitados[i].correo != '') {
        invitados[i].seleccionado = val;
      }
    }
  }

  int _totalSeleccionados() {
    return invitados.where((i) => i.seleccionado).length;
  }

  _enviarCorreos() async {
    List<_InvitadoCorreo> invitadosSeleccionados =
        invitados.where((i) => i.seleccionado).toList();
    _dialogSpinner('Enviando QR...');
    dynamic response = await api.enviarInvitacionesASeleccionados(
      invitadosSeleccionados.map((e) => e.toJson()).toList(),
    );
    Navigator.pop(_dialogContext);
    Navigator.pop(context);
    MostrarAlerta(
      mensaje: response['msg'],
      tipoMensaje:
          response['enviado'] ? TipoMensaje.correcto : TipoMensaje.error,
    );
  }

  _dialogSpinner(String title) {
    Widget child = const LoadingCustom();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        _dialogContext = context;
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: child,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
        );
      },
    );
  }
}

class _InvitadoCorreo {
  int idInvitado;
  String nombre;
  String correo;
  String telefono;
  bool seleccionado = false;

  _InvitadoCorreo(invitado) {
    idInvitado = invitado.idInvitado;
    nombre = invitado.nombre;
    correo = invitado.correo;
    telefono = invitado.telefono;
  }

  Map<String, dynamic> toJson() => {
    'id_invitado': idInvitado,
    'correo': correo,
    'nombre': nombre,
    'telefono': telefono,
  };
}
