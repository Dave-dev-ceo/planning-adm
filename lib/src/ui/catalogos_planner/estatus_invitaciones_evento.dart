import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/estatus/estatus_bloc.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/api_provider.dart';

class ListaEstatusInvitaciones extends StatefulWidget {
  //final int idPlanner;

  const ListaEstatusInvitaciones({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaEstatusInvitaciones(),
      );
  @override
  _ListaEstatusInvitacionesState createState() =>
      _ListaEstatusInvitacionesState();
}

class _ListaEstatusInvitacionesState extends State<ListaEstatusInvitaciones> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  EstatusBloc estatusBloc;
  ItemModelEstatusInvitado itemModelEI;
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  int idPlanner;
  ApiProvider api = new ApiProvider();
  TextEditingController estatusCtrl = new TextEditingController();
  TextEditingController estatusCtrlEdit = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  //_ListaEstatusInvitacionesState(this.idPlanner);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    estatusBloc = BlocProvider.of<EstatusBloc>(context);
    estatusBloc.add(FechtEstatusEvent());
    super.initState();
  }

  listaEstatusInvitaciones(BuildContext cont) {
    ///bloc.dispose();
    /*blocEstatus.fetchAllEstatus(context);
    return StreamBuilder(
      stream: blocEstatus.allEstatus,
      builder: (context, AsyncSnapshot<ItemModelEstatusInvitado> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: LoadingCustom());
      },
    );*/
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

  Future<Map<String, dynamic>> _saveEstatusD(BuildContext context) async {
    Map<String, dynamic> json = {"descripcion": estatusCtrl.text};
    return json;
    // }
  }

  Future<int> _getId() async {
    int id = await _sharedPreferences.getIdPlanner();
    idPlanner = id;
    return id;
  }

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

  _constructorTable(ItemModelEstatusInvitado model) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(15),
            child: formItemsDesign(
                null,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: estatusCtrl,
                        decoration: new InputDecoration(
                          labelText: 'Estatus',
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
                                  color: Colors.black),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: hexToColor('#fdf4e5'),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onTap: () async {
                          Map<String, dynamic> json =
                              await _saveEstatusD(context);
                          await estatusBloc
                              .add(CreateEstatusEvent(json, itemModelEI));
                          estatusCtrl.text = '';
                        },
                      ),
                    ),
                  ],
                ),
                570.0,
                80.0),
          ),
          Center(
            child:
                Container(height: 400.0, width: 600.0, child: buildList(model)
                    //listaEstatusInvitaciones(context),
                    ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getId(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: SingleChildScrollView(
                child: BlocListener<EstatusBloc, EstatusState>(
                  listener: (context, state) {
                    if (state is ErrorTokenEstatusState) {
                      return _showDialogMsg(context);
                    } else if (state is ErrorCreateEstatusState) {
                    } else if (state is ErrorUpdateEstatusState) {}
                  },
                  child: BlocBuilder<EstatusBloc, EstatusState>(
                    builder: (context, state) {
                      if (state is LoadingEstatusState) {
                        return Center(
                          child: LoadingCustom(),
                        );
                      } else if (state is MostrarEstatusState) {
                        //itemModelEI = state.estatus;
                        return _constructorTable(state.estatus);
                        // return Center(child: Text('data'),);
                      } else if (state is ErrorListaEstatusState) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return Center(
                          child: LoadingCustom(),
                        );
                      }
                    },
                  ),
                ),
              ),
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
    /**/
  }

  Widget buildList(ItemModelEstatusInvitado snapshot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _createListItems(snapshot)),
        )
      ],
    );
  }

  List<Widget> _createListItems(ItemModelEstatusInvitado item) {
    // Creación de lista de Widget.
    List<Widget> lista = [];
    // Se agrega el titulo del card
    const titulo = ListTile(
      title: Text('Lista de los estatus',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20)),
    );
    lista.add(titulo);
    // Se agregar lista.
    for (var opt in item.results) {
      final tempWidget = ListTile(
        title: Text(opt.descripcion),
        onTap: () async {
          await _showMyDialogEditar(opt.idEstatusInvitado, opt.descripcion);
        },
      );
      lista.add(tempWidget);
    }
    return lista;
  }

  _saveEstatus(BuildContext context, int idEstatus) async {
    if (keyForm.currentState.validate()) {
      Map<String, String> json = {
        "descripcion": estatusCtrlEdit.text,
        "id_estatus_invitado": idEstatus.toString()
      };
      Navigator.of(context).pop();
      estatusBloc.add(UpdateEstatusEvent(json, itemModelEI, idEstatus));
      //json.
      //bool response = await api.updateEstatus(json, context);
      /*if (response) {
        //_mySelection = "0";
        Navigator.of(context).pop();
        _msgSnackBar('Estatus actualizado', Colors.green[300]);
        //_listaGrupos();
      } else {
        _msgSnackBar('Estatus actualizado', Colors.red[300]);
      }*/
    }
  }

  Future<void> _showMyDialogEditar(int idEstatus, String estatus) async {
    estatusCtrlEdit.text = estatus;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar estatus', textAlign: TextAlign.center),
          content: //SingleChildScrollView(
              //child:
              Form(
            key: keyForm,
            child:
                //ListBody(
                //children: <Widget>[

                TextFormField(
              controller: estatusCtrlEdit,
              decoration: new InputDecoration(
                labelText: 'Estatus',
              ),
              validator: validateEstatus,
            ),

            /*SizedBox(
                  height: 30,
                ),

                GestureDetector(
                        onTap: (){
                          _saveEstatus(context, idEstatus);
                          //
                        },
                        child: CallToAction('Agregar'),
                      ),*/
            //],
            //),
          ),
          //),
          actions: <Widget>[
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                await _saveEstatus(context, idEstatus);
                //Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                estatusBloc.add(DeleteEstatusEvent(idEstatus));
              },
            ),
            /*TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),*/
          ],
        );
      },
    );
  }

  String validateEstatus(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El estatus es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El estatus debe de ser a-z y A-Z";
    }
    return null;
  }
}
