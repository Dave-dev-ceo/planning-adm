part of 'tiposeventos_bloc.dart';

@immutable
abstract class TiposEventosState {}

class TiposEventosInitial extends TiposEventosState {}

class LoadingTiposEventosState extends TiposEventosState {}

class MostrarTiposEventosState extends TiposEventosState {
  final ItemModelTipoEvento? tiposEventos;

  MostrarTiposEventosState(this.tiposEventos);

  ItemModelTipoEvento? get props => tiposEventos;
}

class ErrorCreateTiposEventosState extends TiposEventosState {
  final String message;

  ErrorCreateTiposEventosState(this.message);
  
  List<Object> get props => [message];

}

class ErrorListaTiposEventosState extends TiposEventosState {
  final String message;

  ErrorListaTiposEventosState(this.message);
  
  List<Object> get props => [message];

}
class ErrorTokenTiposEventosState extends TiposEventosState {
  final String message;

  ErrorTokenTiposEventosState(this.message);
  
  List<Object> get props => [message];

}