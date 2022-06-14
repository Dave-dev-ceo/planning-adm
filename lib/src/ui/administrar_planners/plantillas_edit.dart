import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/platillasSistema/plantillas_logic.dart';
import 'package:planning/src/models/PlantillaSistema/plantiila_sistema_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PlantillaEditPage extends StatefulWidget {
  final int idPlantilla;
  const PlantillaEditPage({
    Key key,
    @required this.idPlantilla,
  }) : super(key: key);

  @override
  State<PlantillaEditPage> createState() => _PlantillaEditPageState();
}

class _PlantillaEditPageState extends State<PlantillaEditPage> {
  final _plantillasLogic = PlantillasLogic();
  final HtmlEditorController _controller = HtmlEditorController();

  PlantillaSistemaModel _plantillaSistemaModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantilla'),
      ),
      body: FutureBuilder(
        future: _plantillasLogic.obtenerPantillaById(widget.idPlantilla),
        builder: (BuildContext context,
            AsyncSnapshot<PlantillaSistemaModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              _plantillaSistemaModel = snapshot.data;
              return HtmlEditor(
                htmlToolbarOptions: const HtmlToolbarOptions(
                    buttonFocusColor: Colors.black,
                    buttonSelectedColor: Colors.black),
                controller: _controller,
                htmlEditorOptions: HtmlEditorOptions(
                    hint: "Escriba aqui...",
                    initialText: _plantillaSistemaModel.plantilla),
                otherOptions: OtherOptions(
                  height: size.height,
                ),
              );
            } else {
              Navigator.of(context).pop('Error');
            }
          }
          return const Center(child: LoadingCustom());
        },
      ),
      floatingActionButton: PointerInterceptor(
        child: FloatingActionButton(
          onPressed: () async {
            _plantillaSistemaModel.plantilla = await _controller.getText();

            final data =
                await _plantillasLogic.editarPlantilla(_plantillaSistemaModel);

            if (data) {
              MostrarAlerta(
                  mensaje: 'Se ha editado correctamente la plantilla',
                  tipoMensaje: TipoMensaje.correcto);

              if (mounted) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            } else {
              MostrarAlerta(
                  mensaje:
                      'Ocurrio un error al intentar eliminar editar la plantilla',
                  tipoMensaje: TipoMensaje.error);
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
