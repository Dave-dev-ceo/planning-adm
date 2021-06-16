import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';

class DashboardEventos extends StatefulWidget {
  @override
  _DashboardEventosState createState() => _DashboardEventosState();
}

class _DashboardEventosState extends State<DashboardEventos> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  EventosBloc eventosBloc;
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    eventosBloc = BlocProvider.of<EventosBloc>(context);
    eventosBloc.add(FechtEventosEvent());
    super.initState();
  }
  

  listaEventos(ItemModelEventos eventos) {
    /*bloc.fetchAllEventos(context);
    return StreamBuilder(
      stream: bloc.allEventos,
      builder: (context, AsyncSnapshot<ItemModelEventos> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );*/
  }

  String titulo = "";
  Widget buildList(ItemModelEventos snapshot) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: snapshot.results.length,
        itemBuilder: (BuildContext ctx, index) {
          return miCard(
              snapshot.results.elementAt(index).idEvento,
              snapshot.results.elementAt(index).tipoEvento,
              snapshot.results.elementAt(index).fechaInicio,
              snapshot.results.elementAt(index).fechaFin,
              snapshot.results.elementAt(index).involucrados);
        });
  }

  miCard(int idEvento, String titulo, String inicio, String fin,
      List involucrados) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text(titulo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Fecha Inicio: ' + inicio),
                  Text('Fecha Fin: ' + fin),
                  for (var i = 0; i < involucrados.length; i++)
                    Text(involucrados[i].tipoInvolucrado +
                        ' : ' +
                        involucrados[i].nombre),
                ],
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: () async {
        await _sharedPreferences.setIdEvento(idEvento);
        Navigator.pushNamed(context, '/eventos', arguments: idEvento);
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<EventosBloc, EventosState>(
        listener: (context, state) {
          if (state is ErrorTokenEventosState) {
            return _showDialogMsg(context);
          }
        },
        child: BlocBuilder<EventosBloc, EventosState>(
          builder: (context, state) {
            if (state is LoadingEventosState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MostrarEventosState) {
              return Container(
                child: buildList(state.eventos),
              );
            } else if (state is ErrorListaEventosState) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.event_available),
          backgroundColor: hexToColor('#880B55'),
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/addEvento');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
