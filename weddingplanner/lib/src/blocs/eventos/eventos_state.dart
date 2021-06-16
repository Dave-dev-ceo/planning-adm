part of 'eventos_bloc.dart';

@immutable
abstract class EventosState {}

class EventosInitial extends EventosState {}

class LoadingEventosState extends EventosState {}

class CreateEventosState extends EventosState {}

class CreateEventosOkState extends EventosState {}

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

class ErrorCreateEventosState extends EventosState {
  final String message;

  ErrorCreateEventosState(this.message);
  
  List<Object> get props => [message];

}

class ErrorTokenEventosState extends EventosState {
  final String message;

  ErrorTokenEventosState(this.message);
  
  List<Object> get props => [message];

}