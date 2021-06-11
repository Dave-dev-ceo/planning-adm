import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:weddingplanner/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/models/item_model_etiquetas.dart';
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
  EtiquetasBloc etiquetasBloc;
  MachotesBloc machotesBloc;
  ItemModelEtiquetas itemModelET;
  ItemModelMachotes itemModelMC;
  HtmlEditorController controller;
  TextEditingController  descripcionMachote;
  GlobalKey<FormState> keyForm;
  @override
  void initState() {
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    etiquetasBloc = BlocProvider.of<EtiquetasBloc>(context);
    etiquetasBloc.add(FechtEtiquetasEvent());
    keyForm = new GlobalKey();
    descripcionMachote = new TextEditingController();
    controller = new HtmlEditorController();
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _contectCont(String etiqueta) {
    return Container(
      height: 20,
      child: GestureDetector(
        child: Card(margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Center(child: Text(etiqueta)),
          ),
        ),
        onTap: () async {
          controller.insertText("<¡$etiqueta!>");
        },
      ),
    );
  }
  _constructorLista(ItemModelEtiquetas modelET){
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        for (var i = 0; i < modelET.results.length; i++) _contectCont(modelET.results.elementAt(i).nombreEtiqueta)
      ],
    );
  }
  String validateDescripcion(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El grupo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El grupo debe de ser a-z y A-Z";
    }
    return null;
  }
  _save()async{
    if (keyForm.currentState.validate()) {
      String txt = await controller.getText();
      machotesBloc.add(CreateMachotesEvent({"descripcion":descripcionMachote.text, "machote":txt}, itemModelMC));
    }
  }
  Future<void> _showMyDialogGuardar() async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false,
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
                        
                        _save();
                        Navigator.of(context).pop();
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    'Etiquetas',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: BlocBuilder<EtiquetasBloc, EtiquetasState>(
                  builder: (context, state) {
                    if (state is LoadingEtiquetasState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is MostrarEtiquetasState) {
                      itemModelET = state.etiquetas;
                      return _constructorLista(state.etiquetas);
                    } else if (state is ErrorListaEtiquetasState) {
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
              const Divider(
                height: 20,
                thickness: 5,
              ),
              Container(
                child: HtmlEditor(
                  controller: controller, //required
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: "Ingrese el texto...",
                  ),
                  otherOptions: OtherOptions(
                    height: 580,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          
          await _showMyDialogGuardar();

          //final txt = await controller.getText();
          /*int i = 0;
          String res;
          while (i < datas.length) {
            res =i==0?txt.replaceAll(datas.elementAt(i), dataInfo.elementAt(i)):res.replaceAll(datas.elementAt(i), dataInfo.elementAt(i));
            i++;
          }*/
          //print(txt);

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
