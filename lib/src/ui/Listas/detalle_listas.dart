// ignore_for_file: unused_field, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/lista/detalle_lista/detalle_listas_bloc.dart';
import 'package:planning/src/logic/detalle_listas_logic.dart';
import 'package:planning/src/models/item_model_detalle_listas.dart';
import 'package:planning/src/models/item_model_listas.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';
import 'package:planning/src/utils/utils.dart';

class DetalleListas extends StatefulWidget {
  final Map<String, dynamic> lista;
  const DetalleListas({Key key, this.lista}) : super(key: key);

  @override
  State<DetalleListas> createState() => _DetalleListasState(lista);
}

class _DetalleListasState extends State<DetalleListas> {
  Map<String, dynamic> listas;
  GlobalKey<FormState> keyForm = GlobalKey();
  ItemModelDetalleListas itemModeDetallaLista;
  ItemModelListas itemModelLista;
  // Text para forms lista.
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  // Text para forms detalla de listas.
  TextEditingController cantidadDescCtrl = TextEditingController();
  TextEditingController nombreDescCtrl = TextEditingController();
  TextEditingController descripcionDescCtrl = TextEditingController();
  // Text para forms detalla de listas (Editar).
  TextEditingController cantidadEditarDescCtrl = TextEditingController();
  TextEditingController nombreEditarDescCtrl = TextEditingController();
  TextEditingController descripcionEditarDescCtrl = TextEditingController();

  DetalleListasBloc detalleListasBloc;
  _DetalleListasState(this.listas);

  bool btnAddEditList = false;

  // Declaración variables globales.
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();

  final listaLogic = FetchDetalleListaLogic();

  @override
  void initState() {
    detalleListasBloc = BlocProvider.of<DetalleListasBloc>(context);
    if (listas['id_lista'] == null) {
      detalleListasBloc.add(FechtDetalleListaEvent(0));
    } else if (listas['id_lista'] != null) {
      nombreCtrl.text = listas['nombre'];
      descripcionCtrl.text = listas['descripcion'];
      detalleListasBloc.add(FechtDetalleListaEvent(listas['id_lista']));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detallado de lista'),
        actions: const [],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<DetalleListasBloc, DetalleListasState>(
            builder: (context, state) {
          if (state is MostrarDetalleListasState) {
            return _buildList(state.detlistas);
          } else if (state is CreateListasState) {
            listas['id_lista'] = state.idLista.toString();
            detalleListasBloc.add(FechtDetalleListaEvent(state.idLista));
            return const Text('');
          } else if (listas['id_lista'] != null) {
            return const Center(
              child: LoadingCustom(),
            );
          } else {
            return const Text('');
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.download),
        onPressed: () async {
          final data = await listaLogic
              .downloadPDFDetalleLista(widget.lista['id_lista']);

          if (data != null) {
            downloadFile(data, 'detalles-lista');
          }
        },
      ),
    );
  }

  Widget _formLista() {
    return Card(
      color: Colors.white,
      elevation: 12,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          const Text('Lista',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 24)),
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              TextFormFields(
                icon: Icons.local_activity,
                item: TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                  onChanged: (text) {
                    setState(() {
                      btnAddEditList = true;
                    });
                  },
                ),
                large: 450.0,
                ancho: 90.0,
              ),
              TextFormFields(
                icon: Icons.drive_file_rename_outline,
                item: TextFormField(
                    controller: descripcionCtrl,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onChanged: (text) {
                      setState(() {
                        btnAddEditList = true;
                      });
                    }),
                large: 450.0,
                ancho: 90.0,
              ),
              btnAddEditList
                  ? Ink(
                      padding: const EdgeInsets.all(5),
                      width: 100.0,
                      // height: 100.0,
                      decoration: const ShapeDecoration(
                        color: Colors.black,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.save),
                        color: Colors.white,
                        onPressed: () async {
                          if (listas['id_lista'] == null) {
                            Map<String, dynamic> json =
                                await _jsonAgregarLista(context);
                            detalleListasBloc.add(
                                CreateListasEvent(json, itemModeDetallaLista));
                            MostrarAlerta(
                                mensaje:
                                    'El elemento se actualizó correctamente.',
                                tipoMensaje: TipoMensaje.correcto);
                          } else if (listas['id_lista'] != null) {
                            Map<String, dynamic> json =
                                await _jsonUpdateLista(context);
                            detalleListasBloc.add(
                                UpdateListasEvent(json, itemModeDetallaLista));
                            MostrarAlerta(
                                mensaje: 'El elemento se agrego correctamente.',
                                tipoMensaje: TipoMensaje.correcto);
                          }
                        },
                      ),
                    )
                  : const Text('')
            ],
          )
        ],
      ),
    );
  }

  Widget _formDetalleList() {
    return Card(
      color: Colors.white,
      elevation: 12,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              TextFormFields(
                icon: Icons.tag,
                item: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: cantidadDescCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                  ),
                ),
                large: 200.0,
                ancho: 80.0,
              ),
              TextFormFields(
                icon: Icons.local_activity,
                item: TextFormField(
                  controller: nombreDescCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                large: 350.0,
                ancho: 80.0,
              ),
              TextFormFields(
                icon: Icons.drive_file_rename_outline,
                item: TextFormField(
                  controller: descripcionDescCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                large: 350.0,
                ancho: 80.0,
              ),
              Ink(
                padding: const EdgeInsets.all(5),
                width: 100.0,
                // height: 100.0,
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () async {
                    Map<String, dynamic> json =
                        await _jsonDetalleLista(context);
                    detalleListasBloc.add(
                        CreateDetalleListasEvent(json, itemModeDetallaLista));
                    _limpiarForm();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildList(ItemModelDetalleListas snapshot) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _formLista(),
            if (listas['id_lista'] != null) _formDetalleList(),
            if (listas['id_lista'] != null) _listaDetalle(snapshot)
            // Container(
            //     height: 400.0, width: 650.0, child: _listaDetalle(snapshot)),
          ],
        ),
      ),
    );
  }

  Widget _listaDetalle(ItemModelDetalleListas snapshot) {
    return Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: _createListItems(snapshot)));
  }

  List<Widget> _createListItems(ItemModelDetalleListas item) {
    // Creación de lista de Widget.
    List<Widget> lista = [];
    // Se agrega el titulo del card
    const titulo = Text('Detalles de lista',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24));
    // final campos =
    const size = SizedBox(height: 20);
    lista.add(titulo);
    // lista.add(campos);
    lista.add(size);
    for (var opt in item.results) {
      final tempWidget = ListTile(
        title: Text('${opt.cantidad} - ${opt.nombre}'),
        subtitle: Text(opt.descripcion),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      _eliminarDetalleLista(opt.idDetalleLista, opt.idLista)),
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => _editarDetalleLista(opt)),
              icon: const Icon(Icons.edit)),
        ]),
        onTap: () async {},
      );
      lista.add(tempWidget);
    }
    return lista;
  }

  // Acciones de Agregar.
  // Acciones de editar.

  // Agregar Detalle.
  Future<Map<String, dynamic>> _jsonDetalleLista(BuildContext context) async {
    Map<String, dynamic> json = {
      'cantidad': cantidadDescCtrl.text,
      'nombre': nombreDescCtrl.text,
      'descripcion': descripcionDescCtrl.text,
      'id_lista': listas['id_lista']
    };
    return json;
  }

  void _limpiarForm() {
    cantidadDescCtrl.text = '';
    nombreDescCtrl.text = '';
    descripcionDescCtrl.text = '';
  }

  _eliminarDetalleLista(int idDetalleLista, int idLista) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Desea eliminar el elemento?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => {
            Navigator.pop(context, 'Aceptar'),
            detalleListasBloc
                .add(DeleteDetalleListaEvent(idDetalleLista, idLista))
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _editarDetalleLista(var item) {
    cantidadEditarDescCtrl.text = item.cantidad.toString();
    nombreEditarDescCtrl.text = item.nombre;
    descripcionEditarDescCtrl.text = item.descripcion;
    return AlertDialog(
      title: const Text('Editar'),
      content: SizedBox(
        width: 400.0,
        height: 150.0,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              TextFormField(
                controller: cantidadEditarDescCtrl,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                ),
              ),
              TextFormField(
                controller: nombreEditarDescCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextFormField(
                controller: descripcionEditarDescCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            Map<String, dynamic> json =
                await _jsonEditarDetalleLista(context, item);
            detalleListasBloc
                .add(UpdateDetalleListasEvent(json, itemModeDetallaLista));
            if (mounted) {
              Navigator.pop(context, 'Aceptar');
            }
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  // Agregar Detalle.
  Future<Map<String, dynamic>> _jsonEditarDetalleLista(
      BuildContext context, var item) async {
    Map<String, dynamic> json = {
      'cantidad': cantidadEditarDescCtrl.text,
      'nombre': nombreEditarDescCtrl.text,
      'descripcion': descripcionEditarDescCtrl.text,
      'id_detalle_lista': item.idDetalleLista,
      'id_lista': item.idLista
    };
    return json;
  }

  // Agregar Lista.
  Future<Map<String, dynamic>> _jsonAgregarLista(BuildContext context) async {
    Map<String, dynamic> json = {
      'nombre': nombreCtrl.text,
      'descripcion': descripcionCtrl.text,
    };
    return json;
  }

  Future<Map<String, dynamic>> _jsonUpdateLista(BuildContext context) async {
    Map<String, dynamic> json = {
      'nombre': nombreCtrl.text,
      'descripcion': descripcionCtrl.text,
      'id_lista': listas['id_lista']
    };
    return json;
  }
}
