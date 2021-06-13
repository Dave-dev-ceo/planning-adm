import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_machotes.dart';

class AgregarContrato extends StatefulWidget {
  const AgregarContrato({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarContrato(),
      );

  @override
  _AgregarContratoState createState() => _AgregarContratoState();
}

class _AgregarContratoState extends State<AgregarContrato> {
  MachotesBloc machotesBloc;
  ItemModelMachotes itemModelMC;
  EventosBloc eventosBloc;
  ItemModelEventos itemModelEV;
  @override
  void initState() {
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    machotesBloc.add(FechtMachotesEvent());
    eventosBloc = BlocProvider.of<EventosBloc>(context);
    eventosBloc.add(FechtEventosEvent());
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /*Future<String> _insertEtiquetas(String html){
    eventosBloc.mapEventToState(event)
  }*/

  _contectCont(ItemModelMachotes itemMC, int element) {
    return GestureDetector(
      onTap: () {
        String html = itemMC.results.elementAt(element).machote;

        Navigator.of(context).pushNamed('/addContratoPdf', arguments: html);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text(
                'Machote',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Container(
                  height: 55,
                  //color: Colors.purple,
                  child:
                      Text(itemModelMC.results.elementAt(element).descripcion)),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
    );
  }

  _constructorLista(ItemModelMachotes modelMC) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          for (var i = 0; i < modelMC.results.length; i++)
            _contectCont(modelMC, i)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocBuilder<MachotesBloc, MachotesState>(
          builder: (context, state) {
            if (state is LoadingMachotesState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MostrarMachotesState) {
              itemModelMC = state.machotes;
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
    );
  }
}
