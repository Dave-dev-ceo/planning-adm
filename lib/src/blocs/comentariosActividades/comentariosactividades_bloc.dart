import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:weddingplanner/src/logic/comentarios_actividades_logic.dart';
import 'package:weddingplanner/src/models/item_model_comentarios_actividades.dart';

part 'comentariosactividades_event.dart';
part 'comentariosactividades_state.dart';

class ComentariosactividadesBloc extends Bloc<ComentariosactividadesEvent, ComentariosactividadesState> {
  final ComentariosActividadesLogic logic;
  ComentariosactividadesBloc({@required this.logic}) : super(ComentariosactividadesInitial());

  @override
  Stream<ComentariosactividadesState> mapEventToState(
    ComentariosactividadesEvent event,
  ) async* {
    // implement mapEventToState
    if(event is SelectComentarioPorIdEvent) {
      yield LodingComentarioState();
      try {
        ItemModelComentarios comentario = await logic.selectComentarioPorId();
        yield SelectComentarioState(comentario);
      } on ListaComentarioException {
        yield ErrorMostrarComentarioState('Sin Comentarios');
      } on TokenException {
        yield ErrorTokenComentarioState('Error Token');
      }
    }
    else if(event is CreateComentarioEvent) {
      try {
        int id = await logic.createComentarioPorId(event.txtComentario, event.idActividad, event.estadoComentario);
        yield CreateComentariosState(id);
      } on ListaComentarioException {
        yield ErrorMostrarComentarioState('No se guardo el comentarios');
      } on TokenException {
        yield ErrorTokenComentarioState('Error Token');
      }
    }
    else if(event is UpdateComentarioEvent) {
      try {
        await logic.updateComentarioPorId(event.idComentario,event.txtComentario,event.estadoComentario);
        yield UpdateComentariosState();
      } on ListaComentarioException {
        yield ErrorMostrarComentarioState('No se actualizo el comentarios');
      } on TokenException {
        yield ErrorTokenComentarioState('Error Token');
      }
    }
  }
}
