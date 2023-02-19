import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/plantillasSistema/plantiilas_sistema_bloc.dart';
import 'package:planning/src/models/PlantillaSistema/plantiila_sistema_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class PlantillasSistemaPage extends StatefulWidget {
  const PlantillasSistemaPage({Key? key}) : super(key: key);

  @override
  State<PlantillasSistemaPage> createState() => _PlantillasSistemaPageState();
}

class _PlantillasSistemaPageState extends State<PlantillasSistemaPage> {
  late PlantillasSistemaBloc _plantillasSistemaBloc;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final descripcionPlantilla = TextEditingController();
  int? _grupoRadio = 0;

  List<Map<String, String>> radioB = [
    {
      "nombre": "Contratos",
      'clave': 'CT_T',
    },
    {
      "nombre": "Recibos",
      'clave': 'RC_T',
    },
    {
      "nombre": "Pagos",
      'clave': 'PG_T',
    },
    {
      "nombre": "Minutas",
      'clave': 'MT_T',
    },
    {
      "nombre": "Orden de pedido",
      'clave': 'OP_T',
    },
    {
      "nombre": "Autorizaciones",
      'clave': 'AU_T',
    },
  ];

  final Map<String, String?> _clave = {'clave': 'CT_T'};

  @override
  void initState() {
    _plantillasSistemaBloc = BlocProvider.of<PlantillasSistemaBloc>(context);
    _plantillasSistemaBloc.add(ObtenerPlantillasEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<PlantillasSistemaBloc, PlantillasSistemaState>(
          listener: (context, state) {
            if (state is SuccessInsertPlantillaState) {
              MostrarAlerta(
                  mensaje: 'Se han insertado la plantilla',
                  tipoMensaje: TipoMensaje.correcto);
            }
            if (state is ErrorInsertPlantillaState) {
              MostrarAlerta(
                  mensaje: 'Ha ocurrido un error al insertar la plantilla',
                  tipoMensaje: TipoMensaje.error);
            }

            if (state is SuccessEditDesPlantillaState) {
              MostrarAlerta(
                  mensaje: 'Se ha editado la descripción de la plantilla',
                  tipoMensaje: TipoMensaje.correcto);
            }
            if (state is ErrorEditDesPlantillaState) {
              MostrarAlerta(
                  mensaje:
                      'Ha ocurrido un error al editar la descripción la plantilla',
                  tipoMensaje: TipoMensaje.error);
            }

            if (state is SuccessDeletePlantillaState) {
              MostrarAlerta(
                  mensaje: 'Se ha eliminado correctamente la plantilla',
                  tipoMensaje: TipoMensaje.correcto);
            }

            if (state is ErrorDeletePlantillaState) {
              MostrarAlerta(
                  mensaje:
                      'Ha ocurrido un error al intentar eliminar la plantilla',
                  tipoMensaje: TipoMensaje.error);
            }
          },
          child: BlocBuilder<PlantillasSistemaBloc, PlantillasSistemaState>(
            builder: (context, state) {
              if (state is MostrarPlantillasSistemaState) {
                if (state.plantillas.isNotEmpty) {
                  return buildPlantillasList(state.plantillas);
                } else {
                  return const Center(
                    child: Text('Sin plantillas'),
                  );
                }
              }
              return const Center(child: LoadingCustom());
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogAddPlantilla(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showDialogAddPlantilla(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear plantilla', textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: keyForm,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Column(
                        children: [
                          for (var i = 0; i < radioB.length; i++)
                            RadioListTile(
                                activeColor: Colors.purple,
                                title: Text(radioB[i]['nombre']!),
                                value: i,
                                groupValue: _grupoRadio,
                                onChanged: (int? value) {
                                  setState(
                                    () {
                                      _grupoRadio = value;
                                      _clave['clave'] = radioB[i]['clave'];
                                    },
                                  );
                                })
                        ],
                      ),
                      TextFormField(
                        controller: descripcionPlantilla,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return 'La descripción es necesaria';
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              width: 10.0,
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                if (keyForm.currentState!.validate()) {
                  PlantillaSistemaModel newPlantilla = PlantillaSistemaModel(
                    clavePlantilla: _clave['clave'],
                    descripcion: descripcionPlantilla.text,
                  );

                  _plantillasSistemaBloc
                      .add(InsertPlantillasEvent(newPlantilla));
                  descripcionPlantilla.clear();
                  _grupoRadio = 0;
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildPlantillasList(List<PlantillaSistemaModel> plantillas) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              title: const Text('Contratos'),
              trailing: const Icon(
                Icons.gavel,
                color: Colors.black,
              ),
              children: childrenOfPlantillas(plantillas, 'CT_T'),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              title: const Text('Recibos'),
              trailing: const FaIcon(
                FontAwesomeIcons.moneyCheck,
                color: Colors.black,
              ),
              children: childrenOfPlantillas(plantillas, 'RC_T'),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              title: const Text('Pagos'),
              trailing: const FaIcon(
                FontAwesomeIcons.moneyBill1Wave,
                color: Colors.black,
              ),
              children: childrenOfPlantillas(plantillas, 'PG_T'),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              title: const Text('Minutas'),
              trailing: const FaIcon(
                FontAwesomeIcons.clipboardList,
                color: Colors.black,
              ),
              children: childrenOfPlantillas(plantillas, 'MT_T'),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              title: const Text('Orden de pedido'),
              trailing: const FaIcon(
                FontAwesomeIcons.fileInvoiceDollar,
                color: Colors.black,
              ),
              children: childrenOfPlantillas(plantillas, 'OP_T'),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: Colors.black,
              title: const Text('Autorizaciones'),
              trailing: const FaIcon(
                FontAwesomeIcons.fileContract,
                color: Colors.black,
              ),
              children: childrenOfPlantillas(plantillas, 'AU_T'),
            ),
          ),
          const SizedBox(
            height: 50.0,
          )
        ],
      ),
    );
  }

  List<Widget> childrenOfPlantillas(
      List<PlantillaSistemaModel> plantillas, String clavePlantilla) {
    List<Widget> childrensPlantillas = [];

    for (PlantillaSistemaModel plantilla in plantillas) {
      if (plantilla.clavePlantilla == clavePlantilla) {
        childrensPlantillas.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey[700]!,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: ListTile(
                onTap: () async {
                  Navigator.of(context).pushNamed('/plantillaSistemaEdit',
                      arguments: plantilla.idPlantilla);
                },
                title: Text(plantilla.descripcion!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: const Tooltip(
                        message: 'Editar descripción',
                        child: Icon(Icons.edit),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              final keyFormDescripcion = GlobalKey<FormState>();
                              return AlertDialog(
                                title: const Text('Editar descripción'),
                                content: Form(
                                  key: keyFormDescripcion,
                                  child: TextFormField(
                                    initialValue: plantilla.descripcion,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Descripción',
                                      labelText: 'Descripción',
                                    ),
                                    validator: (value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      }
                                      return 'Inserte la descripción';
                                    },
                                    onChanged: (String value) {
                                      plantilla.descripcion = value;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _plantillasSistemaBloc.add(
                                          EditDescripcionPlantillaEvent(
                                              plantilla));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Aceptar'),
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (contex) => AlertDialog(
                                  title: const Text('Eliminar plantilla'),
                                  content: const Text(
                                      '¿Estás seguro de eliminar la plantilla?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _plantillasSistemaBloc.add(
                                            DeletePlantillaSistemaEvent(
                                                plantilla.idPlantilla));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Aceptar'),
                                    )
                                  ],
                                ));
                      },
                      child: const Tooltip(
                        message: 'Eliminar',
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return childrensPlantillas;
  }
}
