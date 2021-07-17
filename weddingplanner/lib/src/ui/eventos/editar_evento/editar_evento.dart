import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/blocs/tiposEventos/tiposeventos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_evento.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_tipo_evento.dart';
import 'package:weddingplanner/src/ui/eventos/editar_evento/involucradosPorEvento.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';

class EditarEvento extends StatefulWidget {
  final ItemModelEvento evento;
  const EditarEvento({Key key, this.evento}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => EditarEvento(),
      );

  @override
  _EditarEventoState createState() => _EditarEventoState(this.evento);
}

class _EditarEventoState extends State<EditarEvento> {
  final ItemModelEvento evento;
  GlobalKey<FormState> keyForm = new GlobalKey();

  // BuildContext de spinner
  BuildContext _ingresando;

  // Controllers data evento
  TextEditingController descripcionCtrl;
  TextEditingController fechaInicioCtrl;
  TextEditingController fechaFinCtrl;
  TextEditingController fechaEventoCtrl;
  DateTime fechaInicio;
  DateTime fechaFin;
  DateTime fechaEvento;
  String _mySelectionTE = "1";

  // Controllers data Contratante
  TextEditingController nombreCtrl;
  TextEditingController apellidoCtrl;
  TextEditingController telefonoCtrl;
  TextEditingController emailCtrl;
  TextEditingController direccionCtrl;
  TextEditingController estadoCtrl;

  // Controllers data Involucrado
  TextEditingController nombreInvoCtrl;
  TextEditingController telefonoInvoCtrl;
  TextEditingController emailInvoCtrl;
  TextEditingController passwdInvoCtrl;
  TextEditingController passwdConfirmInvoCtrl;
  bool esUsr = false;

  // Booleanos dropdowns
  bool isExpaned = false;
  bool isExpanedT = false;
  bool isExpanedI = true;

  // Blocs y Models
  TiposEventosBloc tiposEventosBloc;
  ItemModelTipoEvento itemModelTipoEvento;
  ItemModelEventos itemModelEventos;
  EventosBloc eventosBloc;

  _EditarEventoState(this.evento) {
    print(this.evento);
  }

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

  _clearControllerEvtCont() {
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
  }

  _clearControllerInvo() {
    nombreInvoCtrl.clear();
    telefonoInvoCtrl.clear();
    emailInvoCtrl.clear();
    passwdInvoCtrl.clear();
    passwdConfirmInvoCtrl.clear();
    setState(() {
      esUsr = false;
    });
  }

  _initEditForm() {
    // Evento
    descripcionCtrl.text = evento.results.elementAt(0).evento;
    fechaInicioCtrl.text = evento.results.elementAt(0).fechaInicio;
    fechaFinCtrl.text = evento.results.elementAt(0).fechaFin;
    fechaEventoCtrl.text = evento.results.elementAt(0).fechaEvento;

    // Contrato
    nombreCtrl.text = evento.results.elementAt(0).nombrect;
    apellidoCtrl.text = evento.results.elementAt(0).apellidoct;
    telefonoCtrl.text = evento.results.elementAt(0).telefonoct;
    emailCtrl.text = evento.results.elementAt(0).emailct;
    direccionCtrl.text = evento.results.elementAt(0).direccionct;
    estadoCtrl.text = evento.results.elementAt(0).estadoct;
  }

  _dialogMSG(String title) {
    Widget child = CircularProgressIndicator();
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<EventosBloc, EventosState>(
        listener: (context, state) {
          if (state is EditarEventosState) {
            return _dialogMSG('Actualizando info. de evento');
          } else if (state is EditarEventosOkState) {
            Navigator.pop(_ingresando);
            final snackBar = SnackBar(
              content: Container(
                height: 30,
                child: Center(
                  child: Text('Evento actualizado'),
                ),
                //color: Colors.red,
              ),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // _clearControllerEvtCont();
          } else if (state is ErrorEditarEventosState) {
            Navigator.pop(_ingresando);
            final snackBar = SnackBar(
              content: Container(
                height: 30,
                child: Center(
                  child: Text('Error al editar evento'),
                ),
                //color: Colors.red,
              ),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: new Container(
            width: 1200,
            margin: new EdgeInsets.all(10.0),
            child: new Form(
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
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // _dropDownTiposEventos(ItemModelTipoEvento tiposEventos) {
  //   return DropdownButton(
  //     value: _mySelectionTE,
  //     icon: const Icon(Icons.arrow_drop_down_outlined),
  //     iconSize: 24,
  //     elevation: 16,
  //     style: const TextStyle(color: Color(0xFF880B55)),
  //     underline: Container(
  //       height: 2,
  //       color: Color(0xFF880B55),
  //     ),
  //     /*onChanged: (newValue) {
  //       setState(() {
  //         _mySelectionTE = newValue;
  //       });
  //     },*/
  //     items: tiposEventos.results.map((item) {
  //       return DropdownMenuItem(
  //         value: item.idTipoEvento.toString(),
  //         child: Text(
  //           item.nombreEvento,
  //           style: TextStyle(fontSize: 18),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 10, child: ListTile(leading: Icon(icon), title: item)),
        width: large,
        height: ancho,
      ),
    );
  }

  String validateDescripcion(String value) {
    if (value.length == 0) {
      return "La descripción es necesaria";
    }
    return null;
  }

  String validateFechaInicio(String value) {
    if (value.length == 0) {
      return "La fecha de inicio es necesaria";
    }
    return null;
  }

  String validateFechaFin(String value) {
    if (value.length == 0) {
      return "La fecha final es necesaria";
    }
    return null;
  }

  String validateFechaEvento(String value) {
    if (value.length == 0) {
      return "La fecha del evento es necesaria";
    }
    return null;
  }

  String validateNombre(String value) {
    /*if (value.length == 0) {
      return "El nombre es necesario";
    }*/
    return null;
  }

  String validateApellido(String value) {
    /*if (value.length == 0) {
      return "El apellido es necesario";
    }*/
    return null;
  }

  String validateTelefono(String value) {
    /*if (value.length == 0) {
      return "El télefono es necesario";
    }*/
    return null;
  }

  String validateEmail(String value) {
    /*if (value.length == 0) {
      return "El correo es necesario";
    }*/
    return null;
  }

  String validateDireccion(String value) {
    /*if (value.length == 0) {
      return "La dirección es necesaria";
    }*/
    return null;
  }

  String validateEstado(String value) {
    /*if (value.length == 0) {
      return "El estado es necesario";
    }*/
    return null;
  }

  _setInitialController() {
    descripcionCtrl = new TextEditingController();
    fechaInicioCtrl = new TextEditingController();
    fechaFinCtrl = new TextEditingController();
    fechaEventoCtrl = new TextEditingController();
    nombreCtrl = new TextEditingController();
    apellidoCtrl = new TextEditingController();
    telefonoCtrl = new TextEditingController();
    emailCtrl = new TextEditingController();
    direccionCtrl = new TextEditingController();
    estadoCtrl = new TextEditingController();
    _initEditForm();
  }

  _selectDateInicio(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: fechaInicio, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaInicio)
      setState(() {
        fechaInicio = picked;
        fechaInicioCtrl.text = fechaInicio.toLocal().toString().split(' ')[0];
      });
  }

  _selectDateFin(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: fechaFin, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaFin)
      setState(() {
        fechaFin = picked;
        fechaFinCtrl.text = fechaFin.toLocal().toString().split(' ')[0];
      });
  }

  _selectDateEvento(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: fechaEvento, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaEvento)
      setState(() {
        fechaEvento = picked;
        fechaEventoCtrl.text = fechaEvento.toLocal().toString().split(' ')[0];
      });
  }

  _save() {
    if (keyForm.currentState.validate()) {
      Map<String, dynamic> jsonEvento = {
        'evtdata': '[{' +
            '"id_evento": ${evento.results.elementAt(0).idEvento.toString()},' +
            '"descripcion_evento": "${descripcionCtrl.text}",' +
            '"fecha_inicio": "${fechaInicioCtrl.text}",' +
            '"fecha_fin": "${fechaFinCtrl.text}",' +
            '"fecha_evento": "${fechaEventoCtrl.text}",' +
            '"id_tipo_evento": $_mySelectionTE' +
            '}]',
        'ctdata': '[{' +
            '"id_contratante": ${evento.results.elementAt(0).idContratante.toString()},' +
            '"nombre": "${nombreCtrl.text}",' +
            '"apellidos": "${apellidoCtrl.text}",' +
            '"telefono": "${telefonoCtrl.text}",' +
            '"correo": "${emailCtrl.text}",' +
            '"direccion": "${direccionCtrl.text}",' +
            '"estado": "${estadoCtrl.text}"' +
            '}]',
        'id_planner': '',
        'id_usuario': ''
      };
      print(jsonEvento.runtimeType);
      eventosBloc.add(EditarEventosEvent(jsonEvento, itemModelEventos));
    }
  }

  formUI() {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 60,
        ),
        ExpansionPanelList(
          animationDuration: Duration(milliseconds: 1000),
          expansionCallback: (int index, bool expaned) {
            setState(() {
              if (index == 0) {
                isExpaned = !isExpaned;
              } else if (index == 1) {
                isExpanedT = !isExpanedT;
              } else {
                isExpanedI = !isExpanedI;
              }
              //print(index);
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return Center(
                    child: Text(
                  'Información general',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpaned,
              body: Container(
                child: Column(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            Icons.notes,
                            TextFormField(
                              controller: descripcionCtrl,
                              decoration: new InputDecoration(
                                labelText: 'Descripción del evento',
                              ),
                              validator: validateDescripcion,
                            ),
                            1000.0,
                            80.0),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        GestureDetector(
                          child: formItemsDesign(
                              Icons.date_range_outlined,
                              TextFormField(
                                controller: fechaInicioCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Fecha Inicio',
                                ),
                                validator: validateFechaInicio,
                              ),
                              500.0,
                              80.0),
                          onTap: () => _selectDateInicio(context),
                        ),
                        GestureDetector(
                          child: formItemsDesign(
                              Icons.date_range_outlined,
                              TextFormField(
                                controller: fechaFinCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Fecha Fin',
                                ),
                                validator: validateFechaFin,
                              ),
                              500.0,
                              80.0),
                          onTap: () => _selectDateFin(context),
                        ),
                      ],
                    ),
                    Wrap(
                      children: <Widget>[
                        GestureDetector(
                          child: formItemsDesign(
                              Icons.date_range_outlined,
                              TextFormField(
                                controller: fechaEventoCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Fecha Evento',
                                ),
                                validator: validateFechaEvento,
                              ),
                              500.0,
                              80.0),
                          onTap: () => _selectDateEvento(context),
                        ),
                        /* Expanded(child: BlocBuilder<TiposEventosBloc, TiposEventosState>(
                          builder: (context, state) {
                            if (state is TiposEventosInitial) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is LoadingTiposEventosState) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is MostrarTiposEventosState) {
                              itemModelTipoEvento = state.tiposEventos;
                              return // SizedBox.shrink();
                              formItemsDesign(
                                    Icons.event,
                                    Row(
                                      children: <Widget>[
                                        Text('Evento'),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        _dropDownTiposEventos(state.tiposEventos),
                                      ],
                                    ),
                                    500.0,
                                    80.0);
                            } else if (state is ErrorListaTiposEventosState) {
                              return Center(
                                child: Text(state.message),
                              );
                              //_showError(context, state.message);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        )), */
                      ],
                    )
                  ],
                ),
              ),
            ),
            ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpaned) {
                  return Center(
                      child: Text(
                    'Datos contrato',
                    style: TextStyle(fontSize: 20.0),
                  ));
                },
                canTapOnHeader: true,
                isExpanded: isExpanedT,
                body: Container(
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          formItemsDesign(
                              Icons.person,
                              TextFormField(
                                controller: nombreCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Nombre',
                                ),
                                validator: validateNombre,
                              ),
                              500.0,
                              80.0),
                          formItemsDesign(
                              null,
                              TextFormField(
                                controller: apellidoCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Apellidos',
                                ),
                                validator: validateApellido,
                              ),
                              500.0,
                              80.0),
                        ],
                      ),
                      Wrap(
                        children: <Widget>[
                          formItemsDesign(
                              Icons.phone,
                              TextFormField(
                                controller: telefonoCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Teléfono',
                                ),
                                validator: validateTelefono,
                              ),
                              500.0,
                              80.0),
                          formItemsDesign(
                              Icons.email,
                              TextFormField(
                                controller: emailCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Correo',
                                ),
                                validator: validateEmail,
                              ),
                              500.0,
                              80.0),
                        ],
                      ),
                      Wrap(
                        children: <Widget>[
                          formItemsDesign(
                              null,
                              TextFormField(
                                controller: direccionCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Dirección completa',
                                ),
                                validator: validateDireccion,
                              ),
                              500.0,
                              80.0),
                          formItemsDesign(
                              null,
                              TextFormField(
                                controller: estadoCtrl,
                                decoration: new InputDecoration(
                                  labelText: 'Estado',
                                ),
                                validator: validateEstado,
                              ),
                              500.0,
                              80.0),
                        ],
                      ),
                    ],
                  ),
                )),
            ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpaned) {
                  return Center(
                      child: Text(
                    'Involucrados',
                    style: TextStyle(fontSize: 20.0),
                  ));
                },
                canTapOnHeader: true,
                isExpanded: isExpanedI,
                body: InvolucradosPorEvento())
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        GestureDetector(
            onTap: () {
              _save();
            },
            child: CallToAction('Guardar'))
      ],
    );
  }
}