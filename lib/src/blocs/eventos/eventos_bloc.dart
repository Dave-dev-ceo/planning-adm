import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/eventos_logic.dart';
import 'package:planning/src/models/item_model_evento.dart';
import 'package:planning/src/models/item_model_eventos.dart';

part 'eventos_event.dart';
part 'eventos_state.dart';

class EventosBloc extends Bloc<EventosEvent, EventosState> {
  final ListaEventosLogic logic;
  EventosBloc({required this.logic}) : super(EventosInitial());

  @override
  Stream<EventosState> mapEventToState(
    EventosEvent event,
  ) async* {
    if (event is FechtEventosEvent) {
      yield LoadingEventosState();

      try {
        ItemModelEventos eventos = await logic.fetchEventos(event.estatus);
        yield MostrarEventosState(eventos);
      } on ListaEventosException {
        yield ErrorListaEventosState("Sin eventos");
      } on TokenException {
        yield ErrorTokenEventosState("Sesión caducada");
      }
    } else if (event is CreateEventosEvent) {
      try {
        yield CreateEventosState();
        int data = await logic.createEventos(event.data);
        if (data == 0) {
          add(FechtEventosEvent('A'));
        }
        yield CreateEventosOkState();
      } on CreateEventoException {
        yield ErrorCreateEventosState("No se pudo insertar");
      } on TokenException {
        yield ErrorTokenEventosState("Sesión caducada");
      }
    } else if (event is EditarEventosEvent) {
      try {
        yield EditarEventosState();
        int data = (await logic.editarEvento(event.data))!;
        yield EditarEventosOkState();
        if (data >= 0) {
          add(FetchEventoPorIdEvent(data.toString()));
        }
      } on EditarEventoException {
        yield ErrorEditarEventosState("No se pudo editar");
      } on TokenException {
        yield ErrorTokenEventosState("Sesión caducada");
      }
    } else if (event is FetchEventoPorIdEvent) {
      yield LoadingEventoPorIdState();
      try {
        ItemModelEvento evento = await logic.fetchEventoPorId(event.idEvento);
        yield MostrarEventoPorIdState(evento);
      } on EventoPorIdException {
        yield ErrorEventoPorIdState("Sin eventos");
      } on TokenException {
        yield ErrorTokenEventosState("Sesión caducada");
      }
    }
  }
}
