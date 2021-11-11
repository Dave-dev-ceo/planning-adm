part of 'eventos_bloc.dart';

@immutable
abstract class EventosState {}

class EventosInitial extends EventosState {}

// Lista Eventos
class LoadingEventosState extends EventosState {}

class MostrarEventosState extends EventosState {
  final ItemModelEventos eventos;

  MostrarEventosState(this.eventos);

  ItemModelEventos get props => eventos;
}

class ErrorListaEventosState extends EventosState {
  final String message;

  ErrorListaEventosState(this.message);

  List<Object> get props => [message];
}

// Evento por id
class LoadingEventoPorIdState extends EventosState {}

class MostrarEventoPorIdState extends EventosState {
  final ItemModelEvento evento;

  MostrarEventoPorIdState(this.evento);

  ItemModelEvento get props => evento;
}

class ErrorEventoPorIdState extends EventosState {
  final String message;

  ErrorEventoPorIdState(this.message);

  List<Object> get props => [message];
}

// Crear Evento
class CreateEventosState extends EventosState {}

class CreateEventosOkState extends EventosState {}

class ErrorCreateEventosState extends EventosState {
  final String message;

  ErrorCreateEventosState(this.message);

  List<Object> get props => [message];
}

// Editar Evento
class EditarEventosState extends EventosState {}

class EditarEventosOkState extends EventosState {}

class ErrorEditarEventosState extends EventosState {
  final String message;

  ErrorEditarEventosState(this.message);

  List<Object> get props => [message];
}

class ErrorTokenEventosState extends EventosState {
  final String message;

  ErrorTokenEventosState(this.message);

  List<Object> get props => [message];
}
