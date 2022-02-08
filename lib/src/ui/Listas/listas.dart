// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/lista/listas_bloc.dart';
import 'package:planning/src/logic/listas_logic.dart';
import 'package:planning/src/models/item_model_listas.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/utils/utils.dart';

class Listas extends StatefulWidget {
  const Listas({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const Listas(),
      );
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Listas> {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  final listaLogic = FetchListaLogic();
  // Id del Planner.
  int idPlanner;
  ListasBloc listasBloc;
  ItemModelListas itemModelListas;
  bool isInvolucrado = false;
  //stilos
  final TextStyle _boldStyle = const TextStyle(fontWeight: FontWeight.bold);
  final TextStyle estiloTxt = const TextStyle(fontWeight: FontWeight.bold);
  // TextEditingController claveCtrl = new TextEditingController();
  // TextEditingController nombreCtrl = new TextEditingController();
  // TextEditingController descripcionCtrl = new TextEditingController();
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
    listasBloc = BlocProvider.of<ListasBloc>(context);
    listasBloc.add(FechtListasEvent());

    checkIsInvolucrado();
  }

  checkIsInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getId(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: (isInvolucrado)
                  ? AppBar(
                      title: const Text('Listas'),
                      centerTitle: true,
                    )
                  : null,
              body: SingleChildScrollView(
                child: BlocListener<ListasBloc, ListasState>(
                  // ignore: void_checks
                  listener: (context, state) {
                    if (state is ErrorTokenListaState) {
                      return _showDialogMsg(context);
                    } else if (state is ErrorCreateListasrState) {
                    } else if (state is ErrorCreateListasrState) {}
                  },
                  child: BlocBuilder<ListasBloc, ListasState>(
                    builder: (context, state) {
                      if (state is LoadingListasState) {
                        return const Center(child: LoadingCustom());
                      } else if (state is MostrarListasState) {
                        if (state.listas != null) {
                          return getLista(state.listas);
                        } else {
                          return const Center(
                            child: Text('Sin datos'),
                          );
                        }
                      } else if (state is ErrorCreateListasrState) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(
                          child: LoadingCustom(),
                        );
                      }
                    },
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: expasionFab(),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('No cuenta con acceso'),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('El sistema tiene un error'),
              ),
            );
          }
        });
  }

  Widget expasionFab() {
    return SpeedDial(
      tooltip: 'Opciones',
      icon: Icons.more_vert,
      children: [
        SpeedDialChild(
          label: 'Crear lista',
          child: const Icon(Icons.add),
          onTap: () async {
            final result = await Navigator.of(context).pushNamed(
                '/detalleListas',
                arguments: {'id_lista': null, 'nombre': '', 'descripcion': ''});
            if (result == null ||
                result == "" ||
                result == false ||
                result == 0) {
              listasBloc.add(FechtListasEvent());
            }
          },
        ),
        SpeedDialChild(
            label: 'Descargar PDF',
            child: const Icon(Icons.download),
            onTap: () async {
              final data = await listaLogic.downloadPDFListas();

              if (data != null) {
                downloadFile(data, 'listas');
              }
            })
      ],
    );
  }

  Widget getLista(ItemModelListas model) {
    return SingleChildScrollView(
      child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          listasBloc.add(FechtListasEvent());
          await _getId();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 400.0, width: 650.0, child: buildList(model)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialogMsg(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          //_ingresando = context;
          return AlertDialog(
            title: const Text(
              "Sesión",
              textAlign: TextAlign.center,
            ),
            content: const Text(
                'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          );
        });
  }

  Future<int> _getId() async {
    int id = await _sharedPreferences.getIdPlanner();
    idPlanner = id;
    return id;
  }

  Widget buildList(ItemModelListas snapshot) {
    return Card(
      color: Colors.white,
      elevation: 12,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView(
        children: _createListItems(snapshot),
      ),
    );
  }

  List<Widget> _createListItems(ItemModelListas item) {
    // Creación de lista de Widget.
    List<Widget> lista = [];
    // Se agrega el titulo del card
    const titulo = Text('Listas',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24));
    lista.add(titulo);
    // Se agregar lista.
    for (var opt in item.results) {
      final tempWidget = ListTile(
        title: Text(opt.nombre),
        subtitle: Text(opt.descripcion),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
              onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      _eliminarLista(opt.idLista)),
              icon: const Icon(Icons.delete))
        ]),
        onTap: () async {
          await Navigator.pushNamed(context, '/detalleListas', arguments: {
            'id_lista': opt.idLista,
            'nombre': opt.nombre,
            'descripcion': opt.descripcion
          }).then((_) => listasBloc.add(FechtListasEvent()));
        },
      );
      lista.add(tempWidget);
    }
    return lista;
  }

  _eliminarLista(int idLista) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text(
          '¿Desea eliminar el elemento? Se eliminará los registros que contenga el elemento.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Map<String, dynamic> json = {'id_lista': idLista};
            Navigator.pop(context, 'Aceptar');
            listasBloc.add(DeleteListaEvent(json));
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(
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
}
