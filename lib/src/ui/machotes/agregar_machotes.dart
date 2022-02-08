// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:planning/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:planning/src/blocs/machotes/machotes_bloc.dart';
import 'package:planning/src/models/item_model_etiquetas.dart';
import 'package:planning/src/models/item_model_machotes.dart';

class AgregarMachote extends StatefulWidget {
  final String descripcionMachote;
  final String claveMachote;
  const AgregarMachote({Key key, this.descripcionMachote, this.claveMachote})
      : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const AgregarMachote(),
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

  HtmlEditorController controller = HtmlEditorController();

  _AgregarMachoteState(this.descripcionMachote, this.claveMachote);
  @override
  void initState() {
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    etiquetasBloc = BlocProvider.of<EtiquetasBloc>(context);
    etiquetasBloc.add(FechtEtiquetasEvent());
    super.initState();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _contectCont(String etiqueta) {
    return SizedBox(
      height: 20,
      child: GestureDetector(
        child: Card(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  'variables',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: BlocBuilder<EtiquetasBloc, EtiquetasState>(
                builder: (context, state) {
                  if (state is LoadingEtiquetasState) {
                    return const Center(
                      child: LoadingCustom(),
                    );
                  } else if (state is MostrarEtiquetasState) {
                    itemModelET = state.etiquetas;
                    return _constructorLista(state.etiquetas);
                  } else if (state is ErrorListaEtiquetasState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const Center(child: LoadingCustom());
                    //return _constructorLista(itemModelET);
                  }
                },
              ),
            ),
            const Divider(
              height: 20,
              thickness: 5,
            ),
            HtmlEditor(
              controller: controller, //required
              htmlEditorOptions: const HtmlEditorOptions(
                autoAdjustHeight: false,
                adjustHeightForKeyboard: false,
                hint: "Ingrese el texto...",
              ),
              otherOptions: OtherOptions(
                height: size.height * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('dasd'),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: PointerInterceptor(
        child: FloatingActionButton(
          heroTag: UniqueKey(),
          child: const Icon(Icons.save),
          onPressed: () async {
            String txt = await controller.getText();
            machotesBloc.add(CreateMachotesEvent({
              "descripcion": descripcionMachote,
              "machote": txt,
              "clave": claveMachote
            }, itemModelMC));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
