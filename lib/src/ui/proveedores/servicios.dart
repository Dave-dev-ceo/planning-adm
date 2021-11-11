import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/models/item_model_servicios.dart';

class Servicios extends StatefulWidget {
  const Servicios({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => Servicios(),
      );
  @override
  _ServiciosState createState() => _ServiciosState();
}

class _ServiciosState extends State<Servicios> {
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController nombreEditCtrl = new TextEditingController();
  ItemModuleServicios itemModuleServicios;
  ServiciosBloc servicioBloc;
  @override
  void initState() {
    servicioBloc = BlocProvider.of<ServiciosBloc>(context);
    servicioBloc.add(FechtServiciosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          formItemsDesign(
              null,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nombreCtrl,
                      decoration: new InputDecoration(
                        labelText: 'Servicio',
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 12),
                        child: FittedBox(
                          child: Text(
                            "Agregar",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w100,
                                color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: hexToColor('#fdf4e5'),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onTap: () async {
                        Map<String, dynamic> json = {'nombre': nombreCtrl.text};
                        servicioBloc.add(
                            CreateServiciosEvent(json, itemModuleServicios));
                        _limpiarForm();
                      },
                    ),
                  ),
                ],
              ),
              570.0,
              80.0),
          BlocBuilder<ServiciosBloc, ServiciosState>(builder: (context, state) {
            if (state is LoadingServiciosState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MostrarServiciosState) {
              return _form(state.listServicios);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })
        ]),
      ),
    );
  }

  Widget _form(ItemModuleServicios moduleServicios) {
    return Container(
        width: double.infinity,
        child: Column(children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(width: 650.0, child: _list(moduleServicios))
                      ],
                    ))),
          )
        ]));
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: ListTile(leading: Icon(icon), title: item)),
        width: large,
        height: ancho,
      ),
    );
  }

  Widget _list(ItemModuleServicios moduleServicios) {
    return Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _createListItems(moduleServicios)));
  }

  List<Widget> _createListItems(ItemModuleServicios item) {
    // Creación de lista de Widget.
    List<Widget> lista = new List<Widget>();
    // Se agrega el titulo del card
    final titulo = Text('Servicios',
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
        title: Text(opt.nombre),
        // subtitle: Text(opt.descripcion),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      _eliminarDetalleLista(opt)),
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

  _eliminarDetalleLista(var item) {
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
            servicioBloc.add(DeleteServicioEvent(item.id_servicio))
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _editarDetalleLista(var item) {
    print(item);
    nombreEditCtrl.text = item.nombre.toString();
    return AlertDialog(
      title: const Text('Editar Servicio'),
      content: Container(
        width: 200.0,
        height: 130.0,
        child: Column(
          children: [
            TextFormField(
              controller: nombreEditCtrl,
              decoration: new InputDecoration(
                labelText: 'Cantidad',
              ),
            ),
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
            Map<String, dynamic> json = {
              'nombre': nombreEditCtrl.text,
              'id_servicio': item.id_servicio.toString()
            };
            servicioBloc.add(UpdateServicioEvent(json, itemModuleServicios));
            Navigator.pop(context, 'Aceptar');
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _limpiarForm() {
    nombreCtrl.text = '';
  }
}
