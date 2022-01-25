import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:planning/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:planning/src/models/item_model_etiquetas.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class FullScreenDialogEditContrato extends StatefulWidget {
  final Map<String, dynamic> data;

  const FullScreenDialogEditContrato({Key key, @required this.data})
      : super(key: key);

  @override
  _FullScreenDialogEditContratoState createState() =>
      _FullScreenDialogEditContratoState(this.data);
}

class _FullScreenDialogEditContratoState
    extends State<FullScreenDialogEditContrato> {
  HtmlEditorController controller = HtmlEditorController();
  ItemModelEtiquetas itemModelET;
  EtiquetasBloc etiquetasBloc;
  ContratosDosBloc contratosBlocDos;
  ApiProvider api = new ApiProvider();
  String machote = '';
  final Map<String, dynamic> data;
  _FullScreenDialogEditContratoState(this.data);

  @override
  void initState() {
    etiquetasBloc = BlocProvider.of<EtiquetasBloc>(context);
    etiquetasBloc.add(FechtEtiquetasEvent());
    contratosBlocDos = BlocProvider.of<ContratosDosBloc>(context);
    contratosBlocDos
        .add(FectValContratoEvent(this.data['id_contrato'].toString()));

    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    setState(() {});
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar contrato'),
          backgroundColor: hexToColor('#fdf4e5'),
          actions: [],
          automaticallyImplyLeading: true,
        ),
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
                      'Variables',
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
                        return Center(child: LoadingCustom());
                      } else if (state is MostrarEtiquetasState) {
                        itemModelET = state.etiquetas;
                        return _constructorLista(state.etiquetas);
                      } else if (state is ErrorListaEtiquetasState) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return Center(child: LoadingCustom());
                        // return _constructorLista(itemModelET);
                      }
                    },
                  ),
                ),
                const Divider(
                  height: 20,
                  thickness: 5,
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.width * 0.8,
                    ),
                    child: BlocBuilder<ContratosDosBloc, ContratosState>(
                        builder: (context, state) {
                      if (state is FectValContratoState) {
                        return HtmlEditor(
                            controller: controller, //required
                            htmlEditorOptions: HtmlEditorOptions(
                                autoAdjustHeight: true,
                                adjustHeightForKeyboard: true,
                                hint: "Escribe aquí...",
                                initialText: state.valor.toString()),
                            otherOptions: OtherOptions(
                              height: size.height * 0.8,
                            ));
                      } else {
                        return Text('data');
                      }
                    })),
              ],
            ),
          ),
        ),
        floatingActionButton: PointerInterceptor(
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            child: Icon(Icons.save),
            onPressed: () async {
              String editArchivo = await controller.getText();
              Map<String, dynamic> dataJson = {
                'id_contrato': data['id_contrato'],
                'archivo': editArchivo
              };
              contratosBlocDos.add(UpdateValContratoEvent(dataJson));
              Navigator.of(context).pop();
              MostrarAlerta(
                  mensaje: 'El contrato se actualizó correctamente.',
                  tipoMensaje: TipoMensaje.correcto);
            },
          ),
        ));
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
          controller.insertText("<¡$etiqueta!>");
        },
      ),
    );
  }
}
