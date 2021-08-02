import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/lista/detalle_lista/detalle_listas_bloc.dart';
import 'package:weddingplanner/src/models/item_model_detalle_listas.dart';
import 'package:weddingplanner/src/models/item_model_listas.dart';
import 'package:weddingplanner/src/ui/widgets/text_form_filed/text_form_filed.dart';

class DetalleListas extends StatefulWidget {
  final Map<String, dynamic> lista;
  const DetalleListas({Key key, this.lista}) : super(key: key);

  @override
  _DetalleListasState createState() => _DetalleListasState(lista);
}

class _DetalleListasState extends State<DetalleListas> {
  Map<String, dynamic> listas;
  GlobalKey<FormState> keyForm = new GlobalKey();
  ItemModelDetalleListas itemModeDetallaLista;
  ItemModelListas itemModelLista;
  // Text para forms lista.
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  // Text para forms detalla de listas.
  TextEditingController cantidadDescCtrl = new TextEditingController();
  TextEditingController nombreDescCtrl = new TextEditingController();
  TextEditingController descripcionDescCtrl = new TextEditingController();
  // Text para forms detalla de listas (Editar).
  TextEditingController cantidadEditarDescCtrl = new TextEditingController();
  TextEditingController nombreEditarDescCtrl = new TextEditingController();
  TextEditingController descripcionEditarDescCtrl = new TextEditingController();

  DetalleListasBloc detalleListasBloc;
  _DetalleListasState(this.listas) {}

  @override
  void initState() {
    detalleListasBloc = BlocProvider.of<DetalleListasBloc>(context);
    if (this.listas['id_lista'] == null) {
      detalleListasBloc.add(FechtDetalleListaEvent(0));
    } else if (this.listas['id_lista'] != null) {
      nombreCtrl.text = this.listas['nombre'];
      descripcionCtrl.text = this.listas['descripcion'];
      detalleListasBloc.add(FechtDetalleListaEvent(this.listas['id_lista']));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detallado de Listas'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<DetalleListasBloc, DetalleListasState>(
            builder: (context, state) {
          if (state is MostrarDetalleListasState) {
            return _buildList(state.detlistas);
          } else if (state is CreateListasState) {
            this.listas['id_lista'] = state.id_lista.toString();
            detalleListasBloc.add(FechtDetalleListaEvent(state.id_lista));
            return Text('');
          } else if (this.listas['id_lista'] != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Text('');
          }
        }),
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
          Text('Listas',
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
                  decoration: new InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                large: 450.0,
                ancho: 90.0,
              ),
              TextFormFields(
                icon: Icons.drive_file_rename_outline,
                item: TextFormField(
                  controller: descripcionCtrl,
                  decoration: new InputDecoration(labelText: 'Descripción'),
                ),
                large: 450.0,
                ancho: 90.0,
              ),
              Ink(
                padding: EdgeInsets.all(5),
                width: 100.0,
                // height: 100.0,
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: this.listas['id_lista'] == null
                      ? const Icon(Icons.save)
                      : const Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () async {
                    if (this.listas['id_lista'] == null) {
                      Map<String, dynamic> json =
                          await _jsonAgregarLista(context);
                      detalleListasBloc
                          .add(CreateListasEvent(json, itemModeDetallaLista));
                      await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: 'Action',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          content: const Text(
                              'El elemento se actualizó correctamente.'),
                          duration: const Duration(milliseconds: 1500),
                          width: 290.0, // Width of the SnackBar.
                          padding: const EdgeInsets.symmetric(
                            horizontal:
                                8.0, // Inner padding for SnackBar content.
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    } else if (this.listas['id_lista'] != null) {
                      Map<String, dynamic> json =
                          await _jsonUpdateLista(context);
                      detalleListasBloc
                          .add(UpdateListasEvent(json, itemModeDetallaLista));
                      await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: 'Action',
                            onPressed: () {
                              // Code to execute.
                            },
                          ),
                          content: const Text(
                              'El elemento se agrego correctamente.'),
                          duration: const Duration(milliseconds: 1500),
                          width: 290.0, // Width of the SnackBar.
                          padding: const EdgeInsets.symmetric(
                            horizontal:
                                8.0, // Inner padding for SnackBar content.
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
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
                  controller: cantidadDescCtrl,
                  decoration: new InputDecoration(
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
                  decoration: new InputDecoration(
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
                  decoration: new InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                large: 350.0,
                ancho: 80.0,
              ),
              Ink(
                padding: EdgeInsets.all(5),
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
                    await _limpiarForm();
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
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _formLista(),
            if (this.listas['id_lista'] != null) _formDetalleList(),
            if (this.listas['id_lista'] != null) _listaDetalle(snapshot)
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
    List<Widget> lista = new List<Widget>();
    // Se agrega el titulo del card
    final titulo = Text('Detalles de Listas',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24));
    // final campos =
    final size = SizedBox(height: 20);
    lista.add(titulo);
    // lista.add(campos);
    lista.add(size);
    for (var opt in item.results) {
      final tempWidget = ListTile(
        title: Text(opt.cantidad.toString() + ' - ' + opt.nombre),
        subtitle: Text(opt.descripcion),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => _eliminarDetalleLista(
                      opt.id_detalle_lista, opt.id_lista)),
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => _editarDetalleLista(opt)),
              icon: const Icon(Icons.edit))
        ]),
        onTap: () async {
          print(opt.nombre);
        },
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
      'id_lista': this.listas['id_lista']
    };
    return json;
  }

  void _limpiarForm() {
    cantidadDescCtrl.text = '';
    nombreDescCtrl.text = '';
    descripcionDescCtrl.text = '';
  }

  _eliminarDetalleLista(int id_detalle_lista, int id_lista) {
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
                .add(DeleteDetalleListaEvent(id_detalle_lista, id_lista))
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
      content: Container(
        width: 400.0,
        height: 150.0,
        child: Column(
          children: [
            TextFormField(
              controller: cantidadEditarDescCtrl,
              decoration: new InputDecoration(
                labelText: 'Cantidad',
              ),
            ),
            TextFormField(
              controller: nombreEditarDescCtrl,
              decoration: new InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextFormField(
              controller: descripcionEditarDescCtrl,
              decoration: new InputDecoration(
                labelText: 'Descripción',
              ),
            )
          ],
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
            Navigator.pop(context, 'Aceptar');
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
      'id_detalle_lista': item.id_detalle_lista,
      'id_lista': item.id_lista
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
      'id_lista': this.listas['id_lista']
    };
    return json;
  }
}
