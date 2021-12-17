import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/machotes/machotes_bloc.dart';
import 'package:planning/src/models/item_model_machotes.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Machotes extends StatefulWidget {
  const Machotes({Key key}) : super(key: key);

  @override
  _MachotesState createState() => _MachotesState();
}

class _MachotesState extends State<Machotes> {
  MachotesBloc machotesBloc;
  ItemModelMachotes itemModelMC;
  List<Map<String, String>> radioB = [
    {"nombre": "Contratos", "clave": "CT"},
    {"nombre": "Recibos", "clave": "RC"},
    {"nombre": "Pagos", "clave": "PG"},
    {"nombre": "Minutas", "clave": "MT"},
    {"nombre": "Oden de pago", "clave": "OP"},
    {"nombre": "Autorizaciones", "clave": "AU"},
  ];
  TextEditingController descripcionMachote;
  GlobalKey<FormState> keyForm;
  int _grupoRadio = 0;
  String _clave = "CT";
  int _selectedIndex = 0;

  List<bool> editsContratos = [];

  @override
  void initState() {
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    machotesBloc.add(FechtMachotesEvent());
    keyForm = new GlobalKey();
    descripcionMachote = new TextEditingController();
    super.initState();
  }

  _goEdit(BuildContext contx) async {
    if (keyForm.currentState.validate()) {
      Navigator.of(contx).pop();
      Navigator.of(context).pushNamed('/addMachote',
          arguments: [descripcionMachote.text, _clave]);
    }
  }

  _contectCont(ItemModelMachotes itemMC, int element) {
    String temp = itemMC.results.elementAt(element).descripcion;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/editPlantilla', arguments: [
          itemMC.results.elementAt(element).descripcion,
          itemMC.results.elementAt(element).clave,
          itemMC.results.elementAt(element).machote,
          itemMC.results.elementAt(element).idMachote.toString()
        ]);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(12),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: Container(
                  alignment: Alignment.topLeft,
                  height: 25,
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                      itemMC.results.elementAt(element).descripcion,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                leading: Icon(Icons.event),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Center(
                              child: Text('Editar nombre de la plantilla'),
                            ),
                            content: ResponsiveGridRow(
                              children: [
                                ResponsiveGridCol(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Nombre de la plantilla'),
                                    initialValue: temp,
                                    onChanged: (value) {
                                      temp = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (temp != '') {
                                    await machotesBloc.add(
                                        UpdateNombreMachoteEvent(
                                            itemMC.results
                                                .elementAt(element)
                                                .idMachote,
                                            temp));
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text('Aceptar'),
                              )
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Eliminar plantilla'),
                            content: Text('¿Desea eliminar la plantilla?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await machotesBloc.add(EliminarMachoteEvent(
                                      itemMC.results
                                          .elementAt(element)
                                          .idMachote));
                                  Navigator.of(context).pop();
                                },
                                child: Text('Aceptar'),
                              )
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _constructorLista(ItemModelMachotes modelMC) {
    return IndexedStack(index: _selectedIndex, children: [
      Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < modelMC.results.length; i++)
              if (modelMC.results.elementAt(i).clave == 'CT')
                _contectCont(modelMC, i)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < modelMC.results.length; i++)
              if (modelMC.results.elementAt(i).clave == 'RC')
                _contectCont(modelMC, i)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < modelMC.results.length; i++)
              if (modelMC.results.elementAt(i).clave == 'PG')
                _contectCont(modelMC, i)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < modelMC.results.length; i++)
              if (modelMC.results.elementAt(i).clave == 'MT')
                _contectCont(modelMC, i)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < modelMC.results.length; i++)
              if (modelMC.results.elementAt(i).clave == 'OP')
                _contectCont(modelMC, i)
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < modelMC.results.length; i++)
              if (modelMC.results.elementAt(i).clave == 'AU')
                _contectCont(modelMC, i)
          ],
        ),
      )
    ]);
  }

  String validateDescripcion(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "La descripción es necesaria";
    } else if (!regExp.hasMatch(value)) {
      return "La descripción debe de ser a-z y A-Z";
    }
    return null;
  }

  Future<void> _showMyDialogGuardar() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear plantilla', textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: keyForm,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Column(
                        children: <Widget>[
                          for (int i = 0; i < radioB.length; i++)
                            ListTile(
                              title: Text(
                                radioB.elementAt(i)['nombre'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.black),
                              ),
                              leading: Radio(
                                value: i,
                                groupValue: _grupoRadio,
                                activeColor: Color(0xFF6200EE),
                                onChanged: (int value) {
                                  setState(() {
                                    _grupoRadio = value;
                                    _clave = radioB.elementAt(i)['clave'];
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                      TextFormField(
                        controller: descripcionMachote,
                        decoration: new InputDecoration(
                          labelText: 'Descripción',
                        ),
                        validator: validateDescripcion,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                await _goEdit(context);
                //_save();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await machotesBloc.add(FechtMachotesEvent());
        },
        child: Container(
          child: BlocBuilder<MachotesBloc, MachotesState>(
            builder: (context, state) {
              if (state is LoadingMachotesState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MostrarMachotesState) {
                itemModelMC = state.machotes;
                editsContratos = [];
                return _constructorLista(state.machotes);
              } else if (state is ErrorListaMachotesState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(child: CircularProgressIndicator());
                //return _constructorLista(itemModelET);
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add),
        onPressed: () async {
          await _showMyDialogGuardar();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'Contratos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Recibos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Pagos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Minutas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Orden de pago',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Autorizaciones',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
