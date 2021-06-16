part of 'eventos_bloc.dart';

@immutable
abstract class EventosEvent {}

class FechtEventosEvent extends EventosEvent {}

class CreateEventosEvent extends EventosEvent {
  final ItemModelEventos eventos;
  final Map<String,dynamic> data;
  CreateEventosEvent(this.data, this.eventos);
  List <Object> get props => [data, eventos];
}