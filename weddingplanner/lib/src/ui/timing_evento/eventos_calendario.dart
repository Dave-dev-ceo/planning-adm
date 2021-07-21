/*
// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/actividadesTiming/actividadestiming_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';

class TimingsEventos extends StatefulWidget {
  const TimingsEventos({Key key}) : super(key: key);

  @override
  _TimingsEventosState createState() => _TimingsEventosState();
}

class _TimingsEventosState extends State<TimingsEventos> {
  // variables bloc
  ActividadestimingBloc eventoTimingBloc;

  // variables model
  ItemModelActividadesTimings itemModel;
  ItemModelActividadesTimings copyItemModel;

  // variables clase
  bool _allCheck = false;
  Map<int,Item> _keepStatus = ({0:Item(isCheck: true)});

  // ini
  @override
  void initState() {
    super.initState();
    eventoTimingBloc = BlocProvider.of<ActividadestimingBloc>(context);
    eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActividadestimingBloc, ActividadestimingState>(
      builder: (context, state) {
        if (state is ActividadestimingInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadingActividadesTimingsState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MostrarActividadesTimingsEventosState) {
            // buscador en header
            if (state.actividadesTimings != null) {
              if(itemModel != state.actividadesTimings){
                itemModel = state.actividadesTimings;
                if (itemModel != null) {
                  copyItemModel = itemModel.copy();
                }
              }
            } else {
              eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
              return Center(child: CircularProgressIndicator());
            }
            if(copyItemModel != null) {
              return _crearVista(copyItemModel);
            }else {
              return Center(child: Text('Sin datos'));
            }
        } else if (state is ErrorMostrarActividadesTimingsState) {
          return Center(child: Text(state.message),);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // cremos vista
  Widget _crearVista(copyItemModel) {
    return Scaffold(
      body: ListView(
        children: [
          StickyHeader(
            header: _agregarHeader(),
            content: _agregarActividades(copyItemModel),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _myBotonSave(),
    );
  }

  // creamos header
  Widget _agregarHeader() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Card(
        child: _crearHeader()
      ),
    );
  }

  Widget _crearHeader() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _tituloHeader(),
          SizedBox(height: 10.0,),
          _buscadorHeader(),
          SizedBox(height: 15.0,),
          _checkActividadesHeader(),
        ],
      ),
    );
  }

  Widget _tituloHeader() {
    return Text('Actividades', style: TextStyle(fontSize: 20.0),);
  }

  Widget _buscadorHeader() {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
          ),
          hintText: 'Buscar...'),
      onChanged: (valor) {_buscadorActividades(valor);},
    );
  }

  Widget _checkActividadesHeader() {
    return Row(
      children: [
        Checkbox(
          value: _allCheck, 
          onChanged: (valor){
            setState((){
              _allCheck = !_allCheck;
              copyItemModel.results.forEach((element) {
                element.addActividad = !_allCheck;
                _changeCheck(copyItemModel,element.idActividad,valor);
              });
            });
          },
        ),
        Text('Selecciona todas las actividades.'),
      ],
    );
  }

  Widget _agregarActividades(copyItemModel) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: listaToda(copyItemModel)
    );
  }

  // Cargar las actividades - eventos/todo
  Future<List<Item>> loadData(ItemModelActividadesTimings itemModel) async {
    // await Future.delayed(Duration(seconds: 3));
    return List.generate(itemModel.results.length, (int index) {
      return Item(
        nombreActividad: '${itemModel.results[index].nombreActividad}',
        descripcionActividad: '${itemModel.results[index].descripcion}',
        idActividad: itemModel.results[index].idActividad,
        isCheck: itemModel.results[index].addActividad,
        isExpanded: itemModel.results[index].addDate,
      );
    });
  }

  List<ExpansionPanel> buildPanelList(List<Item> data) {
    List<ExpansionPanel> children = [];
    for (int i = 0; i < data.length; i++) {
      children.add(ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            leading: Checkbox(
              value: data[i].isCheck ?? false, 
              onChanged: (valor){
                setState((){
                  if(data[i].isExpanded == false) {
                    _changeCheck(copyItemModel,data[i].idActividad,valor);
                    data[i].isCheck = valor;
                  }
                });
              },
            ),
            title: Text("${data[i].nombreActividad}"),
            subtitle: Text("${data[i].descripcionActividad}"),
          );
        },
        isExpanded: data[i].isExpanded ?? false,
        body: ListTile(
          title: Text('Selecciona la fecha.'),
          leading: const Icon(Icons.calendar_today),
          onTap: () {
            setState(() {
              print('Calendary');
            });
          }
        ),
      ));
    }
    return children;
  }

  Widget listaToda(ItemModelActividadesTimings itemModel) {
    if(itemModel.results.length > 0) {
      return FutureBuilder<List<Item>>(
        future: loadData(itemModel),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 500),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      if(snapshot.data[index].isCheck == true) {
                        _changeExpanded(copyItemModel,snapshot.data[index].idActividad, !isExpanded);
                        snapshot.data[index].isExpanded = !isExpanded;
                      }
                    });
                  },
                  children: buildPanelList(snapshot.data)),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
    }
    else {
      return Center(child: Text('Sin datos'));
    }
  }

  _buscadorActividades(String valor) {
    if(valor.length > 2) {
      List<dynamic> buscador = itemModel.results.where((element) =>
        element.nombreActividad.toLowerCase().contains(valor.toLowerCase())
      ).toList();
      setState((){
        copyItemModel.results.clear();
        if(buscador.length > 0) {
          buscador.forEach((element) {
            copyItemModel.results.add(element);
            // rescribir cheks
            copyItemModel.results.forEach((element) {
              if(_keepStatus[element.idActividad] != null)
                element.addActividad = _keepStatus[element.idActividad].isCheck;
            });
          });
        }
        else {}
      });
    } else {
      setState((){
        if (itemModel != null) {
          copyItemModel = itemModel.copy();
          // rescribir cheks
          copyItemModel.results.forEach((element) {
            if(_keepStatus[element.idActividad] != null)
              element.addActividad = _keepStatus[element.idActividad].isCheck;
          });
        }
      });
    }
  }

  void _changeCheck(ItemModelActividadesTimings modelChange, int idActividad,bool newValor) {

    if(_keepStatus[idActividad] == null)
      _keepStatus.addAll({idActividad:Item(isCheck: newValor)});
    else
    _keepStatus[idActividad].isCheck = newValor;

    for(int i = 0; i<modelChange.results.length; i++) {
      if(modelChange.results[i].idActividad == idActividad) {
        modelChange.results[i].addActividad = newValor;
      }
    }
  }

  void _changeExpanded(ItemModelActividadesTimings modelChange, int idActividad,bool newValor) {
    for(int i = 0; i<modelChange.results.length; i++) {
      if(modelChange.results[i].idActividad == idActividad) {
        modelChange.results[i].addDate = newValor;
      }
    }
  }
  // fin Cargar las actividades - eventos/todo
  
  Widget _myBotonSave() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _saveActividades(),
    );
  }

  void _saveActividades() {
    print('Abemus boton!');
  }
  
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.descripcionActividad,
    this.nombreActividad,
    this.idActividad,
    this.isCheck,
    this.isExpanded
  });

  String descripcionActividad;
  String nombreActividad;
  int idActividad;
  bool isCheck;
  bool isExpanded;
}
*/