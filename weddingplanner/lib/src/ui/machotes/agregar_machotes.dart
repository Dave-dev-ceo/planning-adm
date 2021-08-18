import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
import 'package:weddingplanner/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/models/item_model_etiquetas.dart';
import 'package:weddingplanner/src/models/item_model_machotes.dart';
import 'package:zefyrka/zefyrka.dart';

class AgregarMachote extends StatefulWidget {
  final String descripcionMachote;
  final String claveMachote;
  const AgregarMachote({Key key, this.descripcionMachote,this.claveMachote}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarMachote(),
      );

  @override
  _AgregarMachoteState createState() =>
      _AgregarMachoteState(descripcionMachote, claveMachote);
}

class _AgregarMachoteState extends State<AgregarMachote> {
  final String descripcionMachote;
  final String claveMachote;
  EtiquetasBloc etiquetasBloc;
  MachotesBloc machotesBloc;
  ItemModelEtiquetas itemModelET;
  ItemModelMachotes itemModelMC;
  // HtmlEditorController controller = new HtmlEditorController();
  ZefyrController _controller = ZefyrController();

  _AgregarMachoteState(this.descripcionMachote, this.claveMachote);
  @override
  void initState() {
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    etiquetasBloc = BlocProvider.of<EtiquetasBloc>(context);
    etiquetasBloc.add(FechtEtiquetasEvent());
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _contectCont(String etiqueta) {
    return Container(
      height: 20,
      child: GestureDetector(
        child: Card(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Center(child: Text(etiqueta)),
          ),
        ),
        onTap: () async {
          // controller.insertText("<¡$etiqueta!>");
        },
      ),
    );
  }

  _constructorLista(ItemModelEtiquetas modelET) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        for (var i = 0; i < modelET.results.length; i++)
          _contectCont(modelET.results.elementAt(i).nombreEtiqueta)
      ],
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
                    'variables',
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
                    } else {
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
                // child: HtmlEditor(
                //   controller: controller, //required
                //   htmlEditorOptions: HtmlEditorOptions(
                //     hint: "Ingrese el texto...",
                //   ),
                //   otherOptions: OtherOptions(
                //     height: 580,
                //     decoration: BoxDecoration(
                //         border: Border.all(color: Colors.black, width: 1)),
                //   ),
                // ),
                child: Column(
                  children: [
    ZefyrToolbar.basic(controller: _controller),
    Expanded(
      child: ZefyrEditor(
        controller: _controller,
      ),
    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          // String txt = await controller.getText();
          machotesBloc.add(CreateMachotesEvent(
              {"descripcion": descripcionMachote, "machote": 'txt', "clave": claveMachote},
              itemModelMC));
          Navigator.of(context).pop();
          //await _showMyDialogGuardar(context);

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
