part of 'autorizacion_bloc.dart';

@immutable
abstract class AutorizacionState {}

// estado - inicial
class AutorizacionInitial extends AutorizacionState {}

// estado - inicial
class AutorizacionInitialState extends AutorizacionState {}

// estado - cargando
class AutorizacionLodingState extends AutorizacionState {}

// estado - select
class AutorizacionSelectState extends AutorizacionState {
  final ItemModelAutorizacion autorizacion;

  AutorizacionSelectState(this.autorizacion);

  ItemModelAutorizacion get props => autorizacion;
}

// estado - crear
class AutorizacionCreateState extends AutorizacionState {
  final ItemModelAutorizacion autorizacion;

  AutorizacionCreateState(this.autorizacion);

  ItemModelAutorizacion get props => autorizacion;
}

// estado - select id
class SelectEvidenciaState extends AutorizacionState {
  final ItemModelAutorizacion evidencia;

  SelectEvidenciaState(this.evidencia);

  ItemModelAutorizacion get props => evidencia;
}

// estado - errores
class AutorizacionErrorState extends AutorizacionState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends AutorizacionState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}
