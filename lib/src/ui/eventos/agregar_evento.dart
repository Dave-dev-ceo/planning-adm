// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/eventos/eventos_bloc.dart';
import 'package:planning/src/blocs/prospecto/prospecto_bloc.dart';
import 'package:planning/src/blocs/tiposEventos/tiposeventos_bloc.dart';
import 'package:planning/src/models/item_model_eventos.dart';
import 'package:planning/src/models/item_model_tipo_evento.dart';
import 'package:planning/src/models/prospectosModel/prospecto_model.dart';
import 'package:planning/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class AgregarEvento extends StatefulWidget {
  final ProspectoModel prospecto;
  const AgregarEvento({Key key, this.prospecto}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const AgregarEvento(),
      );

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  GlobalKey<FormState> keyForm = GlobalKey();
  BuildContext _ingresando;
  TextEditingController descripcionCtrl;
  TextEditingController nombreCtrl;
  TextEditingController apellidoCtrl;
  TextEditingController telefonoCtrl;
  TextEditingController emailCtrl;
  TextEditingController direccionCtrl;
  TextEditingController estadoCtrl;
  TextEditingController fechaInicioCtrl;
  TextEditingController fechaFinCtrl;
  TextEditingController fechaEventoCtrl;
  TextEditingController numbInvitadosContrl;
  DateTime fechaInicio;
  DateTime fechaFin;
  DateTime fechaEvento;
  bool isExpaned = true;
  bool isExpanedT = false;
  TiposEventosBloc tiposEventosBloc;
  ItemModelTipoEvento itemModelTipoEvento;
  ItemModelEventos itemModelEventos;
  EventosBloc eventosBloc;
  final String _mySelectionTE = "1";

  @override
  void initState() {
    eventosBloc = BlocProvider.of<EventosBloc>(context);
    tiposEventosBloc = BlocProvider.of<TiposEventosBloc>(context);
    tiposEventosBloc.add(FetchTiposEventosEvent());
    _setInitialController();
    fechaInicio = DateTime.now();
    fechaFin = DateTime.now();
    fechaEvento = DateTime.now();
    super.initState();
  }

  _clearController() {
    descripcionCtrl.clear();
    nombreCtrl.clear();
    apellidoCtrl.clear();
    telefonoCtrl.clear();
    emailCtrl.clear();
    direccionCtrl.clear();
    estadoCtrl.clear();
    fechaInicioCtrl.clear();
    fechaFinCtrl.clear();
    fechaEventoCtrl.clear();
    numbInvitadosContrl.clear();
    _setDate();
  }

  _dialogMSG(String title) {
    Widget child = const LoadingCustom();
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          _ingresando = context;
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: child,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<EventosBloc, EventosState>(
        // ignore: void_checks
        listener: (context, state) {
          if (state is CreateEventosState) {
            return _dialogMSG('Creando evento');
          } else if (state is CreateEventosOkState) {
            if (widget.prospecto != null) {
              BlocProvider.of<ProspectoBloc>(context)
                  .add(EventoFromProspectoEvent(widget.prospecto.idProspecto));
            }
            Navigator.pop(_ingresando);

            MostrarAlerta(
                mensaje: 'Evento agregado', tipoMensaje: TipoMensaje.correcto);

            _clearController();
          } else if (state is ErrorCreateEventosState) {
            Navigator.pop(_ingresando);
            MostrarAlerta(
                mensaje: 'Error al crear evento',
                tipoMensaje: TipoMensaje.error);
          }
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Container(
            width: 1200,
            margin: const EdgeInsets.all(10.0),
            child: Form(
              key: keyForm,
              child: formUI(),
            ),
          ),
        ),
      ),
      //),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _dropDownTiposEventos(ItemModelTipoEvento tiposEventos) {
    return DropdownButton(
      onChanged: (value) {},
      value: _mySelectionTE,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF000000)),
      underline: Container(
        height: 2,
        color: const Color(0xFF000000),
      ),
      /*onChanged: (newValue) {
        setState(() {
          _mySelectionTE = newValue;
        });
      },*/
      items: tiposEventos.results.map((item) {
        return DropdownMenuItem(
          value: item.idTipoEvento.toString(),
          child: Text(
            item.nombreEvento,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(
        width: large,
        height: ancho,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: ListTile(leading: Icon(icon), title: item)),
      ),
    );
  }

  String validateDescripcion(String value) {
    if (value.isEmpty) {
      return "La descripción es necesaria";
    }
    return null;
  }

  String validateFechaInicio(String value) {
    if (value.isEmpty) {
      return "La fecha de inicio es necesaria";
    }
    return null;
  }

  String validateFechaFin(String value) {
    if (value.isEmpty) {
      return "La fecha final es necesaria";
    }
    return null;
  }

  String validateFechaEvento(String value) {
    if (value.isEmpty) {
      return "La fecha del evento es necesaria";
    }
    return null;
  }

  String validateNombre(String value) {
    if (value.isEmpty) {
      return "El nombre es necesario";
    }
    return null;
  }

  String validateApellido(String value) {
    if (value.isEmpty) {
      return "El apellido es necesario";
    }
    return null;
  }

  String validateTelefono(String value) {
    if (value.isEmpty) {
      return "El télefono es necesario";
    }
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return "El correo es necesario";
    }
    return null;
  }

  String validateDireccion(String value) {
    if (value.isEmpty) {
      return "La dirección es necesaria";
    }
    return null;
  }

  String validateEstado(String value) {
    if (value.isEmpty) {
      return "El estado es necesario";
    }
    return null;
  }

  _setInitialController() {
    descripcionCtrl = TextEditingController(
        text: (widget.prospecto != null)
            ? widget.prospecto.nombreProspecto
            : null);
    fechaInicioCtrl = TextEditingController();
    fechaFinCtrl = TextEditingController();
    fechaEventoCtrl = TextEditingController();
    nombreCtrl = TextEditingController(
        text: (widget.prospecto != null)
            ? widget.prospecto.involucradoProspecto
            : null);
    apellidoCtrl = TextEditingController();
    telefonoCtrl = TextEditingController(
        text: (widget.prospecto != null)
            ? (widget.prospecto.telefono != null)
                ? widget.prospecto.telefono.toString()
                : null
            : null);
    emailCtrl = TextEditingController(
        text: (widget.prospecto != null) ? widget.prospecto.correo : null);
    direccionCtrl = TextEditingController();
    estadoCtrl = TextEditingController();
    numbInvitadosContrl = TextEditingController();
  }

  _setDate() {
    // fechaInicioCtrl.text = fechaInicio.toLocal().toString().split(' ')[0];
    // fechaFinCtrl.text = fechaFin.toLocal().toString().split(' ')[0];
  }

  _selectDateInicio(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: fechaInicio, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaInicio) {
      setState(() {
        fechaInicio = picked;
        fechaInicioCtrl.text = fechaInicio.toLocal().toString().split(' ')[0];
      });
    }
  }

  _selectDateFin(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: fechaFin, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaFin) {
      setState(() {
        fechaFin = picked;
        fechaFinCtrl.text = fechaFin.toLocal().toString().split(' ')[0];
      });
    }
  }

  _selectDateEvento(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: fechaEvento, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaEvento) {
      setState(() {
        fechaEvento = picked;
        fechaEventoCtrl.text = fechaEvento.toLocal().toString().split(' ')[0];
      });
    }
  }

  _save() async {
    if (keyForm.currentState.validate()) {
      Map<String, dynamic> jsonEvento = {
        "descripcion_evento": descripcionCtrl.text,
        "fecha_inicio": fechaInicioCtrl.text,
        "fecha_fin": fechaFinCtrl.text,
        "fecha_evento": fechaEventoCtrl.text,
        "id_tipo_evento": _mySelectionTE,
        "nombre": nombreCtrl.text,
        "apellidos": apellidoCtrl.text,
        "telefono": telefonoCtrl.text,
        "correo": emailCtrl.text,
        "direccion": direccionCtrl.text,
        "estado": estadoCtrl.text,
        "numeroInvitados": numbInvitadosContrl.text
      };

      eventosBloc.add(CreateEventosEvent(jsonEvento, itemModelEventos));
    }
  }

  formUI() {
    return Column(
      children: <Widget>[
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 1000),
          expansionCallback: (int index, bool expaned) {
            setState(() {
              if (index == 0) {
                isExpaned = !isExpaned;
              } else {
                isExpanedT = !isExpanedT;
              }
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return const Center(
                    child: Text(
                  'Información general',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpaned,
              body: Wrap(
                children: <Widget>[
                  formItemsDesign(
                      Icons.notes,
                      TextFormField(
                        controller: descripcionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Descripción del evento',
                        ),
                        validator: validateDescripcion,
                      ),
                      450.0,
                      80.0),
                  GestureDetector(
                    child: formItemsDesign(
                        Icons.date_range_outlined,
                        TextFormField(
                          readOnly: true,
                          onTap: () => _selectDateInicio(context),
                          controller: fechaInicioCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Fecha inicio',
                          ),
                          validator: validateFechaInicio,
                        ),
                        450.0,
                        80.0),
                    onTap: () => _selectDateInicio(context),
                  ),
                  GestureDetector(
                    child: formItemsDesign(
                        Icons.date_range_outlined,
                        TextFormField(
                          readOnly: true,
                          onTap: () => _selectDateFin(context),
                          controller: fechaFinCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Fecha fin',
                          ),
                          validator: validateFechaFin,
                        ),
                        450.0,
                        80.0),
                    onTap: () => _selectDateFin(context),
                  ),
                  GestureDetector(
                    child: formItemsDesign(
                        Icons.date_range_outlined,
                        TextFormField(
                          onTap: () => _selectDateEvento(context),
                          controller: fechaEventoCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Fecha evento',
                          ),
                          validator: validateFechaEvento,
                        ),
                        450.0,
                        80.0),
                    onTap: () => _selectDateEvento(context),
                  ),
                  const SizedBox(
                    height: 150.0,
                  )
                ],
              ),
            ),
            ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpaned) {
                  return const Center(
                      child: Text(
                    'Datos contrato',
                    style: TextStyle(fontSize: 20.0),
                  ));
                },
                canTapOnHeader: true,
                isExpanded: isExpanedT,
                body: Column(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            Icons.person,
                            TextFormField(
                              controller: nombreCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Nombre completo',
                              ),
                              validator: validateNombre,
                            ),
                            900.0,
                            80.0),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            Icons.phone,
                            TextFormField(
                              controller: telefonoCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                              ),
                              validator: validateTelefono,
                            ),
                            450.0,
                            80.0),
                        formItemsDesign(
                            Icons.email,
                            TextFormField(
                              controller: emailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Correo',
                              ),
                              validator: validateEmail,
                            ),
                            450.0,
                            80.0),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            Icons.home,
                            TextFormField(
                              controller: direccionCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Dirección completa',
                              ),
                              validator: validateDireccion,
                            ),
                            450.0,
                            80.0),
                        formItemsDesign(
                            Icons.map,
                            TextFormField(
                              controller: estadoCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                              ),
                              validator: validateEstado,
                            ),
                            450.0,
                            80.0),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    )
                  ],
                ))
          ],
        ),
        const SizedBox(
          height: 30.0,
        ),
        GestureDetector(
            onTap: () {
              _save();
            },
            child: const CallToAction('Guardar'))
      ],
    );
  }
}
