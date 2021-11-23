import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/blocs/lista/listas_bloc.dart';
import 'package:planning/src/logic/listas_logic.dart';
import 'package:planning/src/models/item_model_listas.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/utils/utils.dart';

class Listas extends StatefulWidget {
  const Listas({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => Listas(),
      );
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Listas> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final listaLogic = FetchListaLogic();
  // Id del Planner.
  int idPlanner;
  ListasBloc listasBloc;
  ItemModelListas itemModelListas;
  //stilos
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);

  // TextEditingController claveCtrl = new TextEditingController();
  // TextEditingController nombreCtrl = new TextEditingController();
  // TextEditingController descripcionCtrl = new TextEditingController();
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
    listasBloc = BlocProvider.of<ListasBloc>(context);
    listasBloc.add(FechtListasEvent());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getId(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: SingleChildScrollView(
                child: BlocListener<ListasBloc, ListasState>(
                  listener: (context, state) {
                    if (state is ErrorTokenListaState) {
                      return _showDialogMsg(context);
                    } else if (state is ErrorCreateListasrState) {
                    } else if (state is ErrorCreateListasrState) {}
                  },
                  child: BlocBuilder<ListasBloc, ListasState>(
                    builder: (context, state) {
                      if (state is LoadingListasState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is MostrarListasState) {
                        return getLista(state.listas);
                      } else if (state is ErrorCreateListasrState) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: CircularProgressIndicator());
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
            return Scaffold(
              body: Container(
                child: Center(
                  child: Text('No cuenta con acceso'),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
                child: Center(
                  child: Text('El sistema tiene un error'),
                ),
              ),
            );
          }
        });
  }

  Widget expasionFab() {
    return SpeedDial(
      icon: Icons.more_vert_outlined,
      children: [
        SpeedDialChild(
          label: 'Crear lista',
          child: Icon(Icons.add),
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
            child: Icon(Icons.download),
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
          await listasBloc.add(FechtListasEvent());
          await _getId();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 400.0, width: 650.0, child: buildList(model)),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * 
   */
  _showDialogMsg(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          //_ingresando = context;
          return AlertDialog(
            title: Text(
              "Sesión",
              textAlign: TextAlign.center,
            ),
            content: Text(
                'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                child: Text('Cerrar'),
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
    List<Widget> lista = new List<Widget>();
    // Se agrega el titulo del card
    final titulo = Text('Listas',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24));
    lista.add(titulo);
    // Se agregar lista.
    for (var opt in item.results) {
      final tempWidget = ListTile(
        title: Text(opt.nombre),
        subtitle: Text(opt.descripcion),
        onTap: () async {
          await Navigator.pushNamed(context, '/detalleListas', arguments: {
            'id_lista': opt.idLista,
            'nombre': opt.nombre,
            'descripcion': opt.descripcion
          });
        },
      );
      lista.add(tempWidget);
    }
    return lista;
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

  // void _limpiarForm() {
  //   claveCtrl.text = '';
  //   nombreCtrl.text = '';
  //   descripcionCtrl.text = '';
  // }
}
