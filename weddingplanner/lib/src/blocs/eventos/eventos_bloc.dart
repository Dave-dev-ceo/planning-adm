import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/eventos_logic.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';

part 'eventos_event.dart';
part 'eventos_state.dart';

class EventosBloc extends Bloc<EventosEvent, EventosState> {
  final ListaEventosLogic logic;
  EventosBloc({@required this.logic}) : super(EventosInitial());

  @override
  Stream<EventosState> mapEventToState(
    EventosEvent event,
  ) async* {
    if(event is FechtEventosEvent){
      yield LoadingEventosState();

      try {
        
        ItemModelEventos eventos = await logic.fetchEventos();
        yield MostrarEventosState(eventos);

      }on ListaEventosException{
        
        yield ErrorListaEventosState("Sin eventos");
      
      }on TokenException{
        yield ErrorTokenEventosState("Sesión caducada");
      }
    }else if(event is CreateEventosEvent){
      try {
        yield CreateEventosState();
        Map<String,dynamic> jsonMap = await logic.createEventos(event.data);
        /*ItemModelEventos model = event.eventos;
        //String dato = event.data['descripcion'];
        Map<String,dynamic> lista = {
          'id_evento':jsonMap['id_evento'],
          'fecha_inicio':event.data['fecha_inicio'],
          'fecha_fin':event.data['fecha_fin'],
          'tipo_evento':'Boda',
          'involucrados':{"nombre":"Sin nombre", "tipo_involucrado":"Sin involucrado"}
          };
        Evento est = new Evento(lista);
        model.results.add(est);
        //yield CreateEstatusState(estatus);
        yield MostrarEventosState(model);*/
        
        add(FechtEventosEvent());
        yield CreateEventosOkState();
      }on CreateEventoException{
        yield ErrorCreateEventosState("No se pudo insertar");
      }
    }
  }
}
