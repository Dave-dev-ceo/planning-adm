import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/models/item_model_servicios.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class Servicios extends StatefulWidget {
  const Servicios({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const Servicios(),
      );
  @override
  State<Servicios> createState() => _ServiciosState();
}

class _ServiciosState extends State<Servicios> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController nombreEditCtrl = TextEditingController();
  ItemModuleServicios? itemModuleServicios;
  late ServiciosBloc servicioBloc;
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
                      decoration: const InputDecoration(
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
                        decoration: BoxDecoration(
                          color: hexToColor('#fdf4e5'),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const FittedBox(
                          child: Text(
                            "Agregar",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w100,
                                color: Colors.black),
                          ),
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
              return const Center(child: LoadingCustom());
            } else if (state is MostrarServiciosState) {
              return _form(state.listServicios);
            } else {
              return const Center(child: LoadingCustom());
            }
          })
        ]),
      ),
    );
  }

  Widget _form(ItemModuleServicios moduleServicios) {
    return SizedBox(
        width: double.infinity,
        child: Column(children: <Widget>[
          const SizedBox(
            height: 50.0,
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 650.0, child: _list(moduleServicios))
                      ],
                    ))),
          )
        ]));
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
    List<Widget> lista = [];
    // Se agrega el titulo del card
    const titulo = Text('Servicios',
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
        title: Text(opt.nombre!),
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
        onTap: () async {},
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
            servicioBloc.add(DeleteServicioEvent(item.idServicio)),
            MostrarAlerta(
                mensaje: 'Se eliminó el servicio.',
                tipoMensaje: TipoMensaje.correcto)
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _editarDetalleLista(var item) {
    nombreEditCtrl.text = item.nombre.toString();
    return AlertDialog(
      title: const Text('Editar servicio'),
      content: SizedBox(
        width: 200.0,
        height: 130.0,
        child: Column(
          children: [
            TextFormField(
              controller: nombreEditCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
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
              'id_servicio': item.idServicio.toString()
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
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _limpiarForm() {
    nombreCtrl.text = '';
  }
}
