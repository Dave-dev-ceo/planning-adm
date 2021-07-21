part of 'rol_bloc.dart';

@immutable
abstract class RolState {}

class RolInitial extends RolState {}

// ESTADOS DE ALTA DE USUARIO

class LoadingCrearRolState extends RolState {}

class RolCreadoState extends RolState {
  final ItemModelRol rol;
  RolCreadoState(this.rol);
  ItemModelRol get data => this.rol;
}

class ErrorCrearRolState extends RolState {
  final String message;
  ErrorCrearRolState(this.message);

  List<Object> get props => [message];
}

// ESTADOS DE EDICION DE USUARIO

class LoadingEditarRolState extends RolState {}

class RolEditadoState extends RolState {
  final ItemModelRol rol;
  RolEditadoState(this.rol);
  ItemModelRol get data => this.rol;
}

class ErrorEditarRolState extends RolState {
  final String message;
  ErrorEditarRolState(this.message);
  List<Object> get props => [message];
}

// ESTADOS DE CONSULTA DE USUARIO

class LoadingMostrarRolState extends RolState {}

class MostrarRolState extends RolState {
  final ItemModelRol rol;
  MostrarRolState(this.rol);
  ItemModelRol get props => rol;
}

class ErrorMostrarRolState extends RolState {
  final String message;
  ErrorMostrarRolState(this.message);
  List<Object> get props => [message];
}

// ERROR EN TOKEN:

class ErrorTokenRolState extends RolState {
  final String message;
  ErrorTokenRolState(this.message);
  List<Object> get props => [message];
}
