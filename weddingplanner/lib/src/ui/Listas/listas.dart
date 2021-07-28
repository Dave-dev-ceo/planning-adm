import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/lista/listas_bloc.dart';
import 'package:weddingplanner/src/models/item_model_listas.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';

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
  // Id del Planner.
  int idPlanner;
  ListasBloc listasBloc;
  ItemModelListas itemModelListas;
  //stilos
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  TextEditingController claveCantidadCtrl = new TextEditingController();
  TextEditingController nombreDescripcionCtrl = new TextEditingController();
  TextEditingController descripcionActividadCtrl = new TextEditingController();
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
                        print(state.message);
                      } else if (state is ErrorCreateListasrState) {
                        print(state.message);
                      }
                    },
                    child: BlocBuilder<ListasBloc, ListasState>(
                      builder: (context, state) {
                        if (state is LoadingListasState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is MostrarListasState) {
                          print('State en from');
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
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () async {
                    // Navigator.of(context).pushNamed('/addPlanners');
                    print('Agregar lista------>  ');
                    Map<String, dynamic> json = await _saveArticulo(context);
                    print(json);
                    listasBloc.add(CreateListasEvent(json, itemModelListas));
                    await _limpiarForm();
                  },
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.startDocked);
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

  Widget getLista(ItemModelListas model) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Card(
                color: Colors.white,
                elevation: 12,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Listas', style: TextStyle(fontSize: 24)),
                    Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            null,
                            TextFormField(
                              controller: claveCantidadCtrl,
                              decoration:
                                  new InputDecoration(labelText: 'Clave'),
                            ),
                            500.0,
                            80.0),
                        formItemsDesign(
                            null,
                            TextFormField(
                              controller: descripcionActividadCtrl,
                              decoration:
                                  new InputDecoration(labelText: 'Nombre'),
                            ),
                            500.0,
                            80.0),
                        formItemsDesign(
                            null,
                            TextFormField(
                              controller: nombreDescripcionCtrl,
                              decoration:
                                  new InputDecoration(labelText: 'Descripción'),
                            ),
                            500.0,
                            80.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                child: Container(
                    height: 400.0, width: 600.0, child: buildList(model)))
          ],
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
    List<Widget> lista = new List<Widget>();

    for (var opt in item.results) {
      final tempWidget = ListTile(
        title: Text(opt.clave + ' - ' + opt.nombre),
        subtitle: Text(opt.descripcion),
        onTap: () async {
          print(opt.clave);
          await Navigator.pushNamed(context, '/detalleListas',
              arguments: {'event': item});
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

  Future<Map<String, dynamic>> _saveArticulo(BuildContext context) async {
    Map<String, dynamic> json = {
      'clave': claveCantidadCtrl.text,
      'nombre': nombreDescripcionCtrl.text,
      'descripcion': descripcionActividadCtrl.text
    };
    return json;
  }

  void _limpiarForm() {
    claveCantidadCtrl.text = '';
    nombreDescripcionCtrl.text = '';
    descripcionActividadCtrl.text = '';
  }
}
