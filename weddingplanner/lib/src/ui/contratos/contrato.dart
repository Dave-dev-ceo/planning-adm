import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/models/item_model_machotes.dart';
import 'package:weddingplanner/src/ui/widgets/cards/cards.dart';


class Contratos extends StatefulWidget {
  const Contratos({ Key key }) : super(key: key);

  @override
  _ContratosState createState() => _ContratosState();
}

class _ContratosState extends State<Contratos> {
  MachotesBloc machotesBloc;
  ItemModelMachotes itemModelMC;

  TextEditingController  descripcionMachote;
  GlobalKey<FormState> keyForm;

  @override
  void initState(){
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    machotesBloc.add(FechtMachotesEvent());
    keyForm = new GlobalKey();
    descripcionMachote = new TextEditingController();
    super.initState();

  }
  _goEdit(BuildContext contx)async{
    if (keyForm.currentState.validate()) {
      Navigator.of(contx).pop();
      Navigator.of(context).pushNamed('/addContrato',arguments: descripcionMachote.text);
      
    }
  }

  _contectCont(String etiqueta) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text('Machote',style: TextStyle(fontSize: 20),),
              subtitle: 
                  Container(
                    height: 55,
                    //color: Colors.purple,
                    child: Text(etiqueta)
                  ),

              
              leading: Icon(Icons.event),
            ),
          ],
        ),
      );
    /*return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Spendings(
        name: "Machote",
        amount: etiqueta,
      ),
    );*/
    /*return Container(
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
    );*/
  }
 
  _constructorLista(ItemModelMachotes modelMC){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          for (var i = 0; i < modelMC.results.length; i++) _contectCont(modelMC.results.elementAt(i).descripcion)
        ],
      ),
    );
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
          title: Text('Ingrese una descripción', textAlign: TextAlign.center),
          content: 
          Form(
            key: keyForm,
            child: 
                TextFormField(
                  controller: descripcionMachote,
                  decoration: new InputDecoration(
                    labelText: 'Descripción',
                  ),
                  validator: validateDescripcion,
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10.0,),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async{
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
        onPressed: ()async{  
          await _showMyDialogGuardar();
        },
      ),
    );
  }
}