import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/models/item_model_machotes.dart';


class Contratos extends StatefulWidget {
  const Contratos({ Key key }) : super(key: key);

  @override
  _ContratosState createState() => _ContratosState();
}

class _ContratosState extends State<Contratos> {
  MachotesBloc machotesBloc;
  ItemModelMachotes itemModelMC;

  @override
  void initState(){
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    machotesBloc.add(FechtMachotesEvent());
    super.initState();

  }

  _contectCont(String etiqueta) {
    return Container(
      height: 60,
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: ListTile(
              title: Icon(Icons.paste_rounded),
              subtitle: Text(etiqueta),
            ),
          ) 
        ),
        onTap: (){
          
        },
      ),
    );
  }
 
  _constructorLista(ItemModelMachotes modelMC){
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        for (var i = 0; i < modelMC.results.length; i++) _contectCont(modelMC.results.elementAt(i).descripcion)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
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
            }else{
              return Center(child: CircularProgressIndicator());
              //return _constructorLista(itemModelET);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){  
          Navigator.of(context).pushNamed('/addContrato');
        },
      ),
    );
  }
}