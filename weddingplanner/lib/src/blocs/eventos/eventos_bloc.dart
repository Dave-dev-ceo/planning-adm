import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/eventos_logic.dart';
import 'package:weddingplanner/src/models/item_model_evento.dart';
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
    if (event is FechtEventosEvent) {
      yield LoadingEventosState();

      try {
        ItemModelEventos eventos = await logic.fetchEventos();
        yield MostrarEventosState(eventos);
      } on ListaEventosException {
        yield ErrorListaEventosState("Sin eventos");
      } on TokenException {
        yield ErrorTokenEventosState("Sesión caducada");
      }
    } else if (event is CreateEventosEvent) {
      try {
        yield CreateEventosState();
        Map<String, dynamic> jsonMap = await logic.createEventos(event.data);
        add(FechtEventosEvent());
        yield CreateEventosOkState();
      } on CreateEventoException {
        yield ErrorCreateEventosState("No se pudo insertar");
      }
    } else if (event is FetchEventoPorIdEvent) {
      yield LoadingEventoPorIdState();

      try {
        ItemModelEvento evento = await logic.fetchEventoPorId(event.id_evento);
        yield MostrarEventoPorIdState(evento);
      } on EventoPorIdException {
        yield ErrorEventoPorIdState("Sin eventos");
      } on TokenException {
        yield ErrorTokenEventosState("Sesión caducada");
      }
    }
  }
}
