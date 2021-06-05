part of 'eventos_bloc.dart';

@immutable
abstract class EventosState {}

class EventosInitial extends EventosState {}

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

class ErrorTokenEventosState extends EventosState {
  final String message;

  ErrorTokenEventosState(this.message);
  
  List<Object> get props => [message];

}