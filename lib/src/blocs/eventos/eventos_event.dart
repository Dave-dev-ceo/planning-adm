part of 'eventos_bloc.dart';

@immutable
abstract class EventosEvent {}

class FechtEventosEvent extends EventosEvent {
  final String estatus;
  FechtEventosEvent(this.estatus);
}

class CreateEventosEvent extends EventosEvent {
  final ItemModelEventos eventos;
  final Map<String, dynamic> data;
  CreateEventosEvent(this.data, this.eventos);
  List<Object> get props => [data, eventos];
}

class EditarEventosEvent extends EventosEvent {
  final ItemModelEventos eventos;
  final Map<String, dynamic> data;
  EditarEventosEvent(this.data, this.eventos);
  List<Object> get props => [data, eventos];
}

class FetchEventoPorIdEvent extends EventosEvent {
  final String idEvento;

  FetchEventoPorIdEvent(this.idEvento);
  List<Object> get props => [idEvento];
}
