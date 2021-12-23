import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/etiquetas_logic.dart';
import 'package:planning/src/models/item_model_etiquetas.dart';

part 'etiquetas_event.dart';
part 'etiquetas_state.dart';

class EtiquetasBloc extends Bloc<EtiquetasEvent, EtiquetasState> {
  final ListaEtiquetasLogic logic;
  EtiquetasBloc({@required this.logic}) : super(EtiquetasInitial());

  @override
  Stream<EtiquetasState> mapEventToState(
    EtiquetasEvent event,
  ) async* {
    if (event is FechtEtiquetasEvent) {
      yield LoadingEtiquetasState();

      try {
        ItemModelEtiquetas etiquetas = await logic.fetchEtiquetas();
        yield MostrarEtiquetasState(etiquetas);
      } on ListaEtiquetasException {
        yield ErrorListaEtiquetasState("Sin etiquetas");
      } on TokenException {
        yield ErrorTokenEtiquetasState("Sesión caducada");
      }
    } else if (event is CreateEtiquetasEvent) {
      try {
        int idEtiquetas = await logic.createEtiquetas(event.data);
        ItemModelEtiquetas model = event.etiquetas;
        String dato = event.data['nombre_etiqueta'];
        String tipo = event.data['tipo_etiqueta'];
        Map<String, dynamic> lista = {
          'id_etiqueta': idEtiquetas,
          'nombre_etiqueta': dato,
          'tipo_etiqueta': tipo
        };
        Etiquetas est = new Etiquetas(lista);
        model.results.add(est);
        //yield CreateEtiquetasState(etiquetas);
        yield MostrarEtiquetasState(model);
      } on CreateEtiquetasException {
        yield ErrorCreateEtiquetasState("No se pudo insertar");
      }
    } else if (event is UpdateEtiquetasEvent) {
      bool response = await logic.updateEtiquetas(event.data);
      ItemModelEtiquetas model = event.etiquetas;
      if (response) {
        //model.results[event.id].addDescripcion = event.data['descripcion'];
        for (int i = 0; i < model.results.length; i++) {
          if (model.results.elementAt(i).idEtiqueta == event.id) {
            model.results.elementAt(i).addNombreEtiqueta =
                event.data['descripcion'];
          }
        }
      }
      yield MostrarEtiquetasState(model);
    }
  }
}
