part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioState {}

class UsuarioInitial extends UsuarioState {}

// ESTADOS DE ALTA DE USUARIO

class LoadingCrearUsuarioState extends UsuarioState {}

class UsuarioCreadoState extends UsuarioState {}

class ErrorCrearUsuarioState extends UsuarioState {
  final String message;
  ErrorCrearUsuarioState(this.message);

  List<Object> get props => [message];
}

// ESTADOS DE BAJA DE USUARIO

class LoadingEliminarUsuarioState extends UsuarioState {}

class UsuarioEliminadoState extends UsuarioState {
  final bool eliminado;
  UsuarioEliminadoState(this.eliminado);
}

class ErrorEliminarUsuarioState extends UsuarioState {
  final String message;
  ErrorEliminarUsuarioState(this.message);
  List<Object> get props => [message];
}

// ESTADOS DE EDICION DE USUARIO

class LoadingEditarUsuarioState extends UsuarioState {}

class UsuarioEditadoState extends UsuarioState {}

class ErrorEditarUsuarioState extends UsuarioState {
  final String message;
  ErrorEditarUsuarioState(this.message);
  List<Object> get props => [message];
}

// ESTADOS DE CONSULTA DE USUARIO

class LoadingMostrarUsuarioState extends UsuarioState {}

class MostrarUsuarioState extends UsuarioState {
  final ItemModelUsuario usuario;
  MostrarUsuarioState(this.usuario);
  ItemModelUsuario get props => usuario;
}

class ErrorMostrarUsuarioState extends UsuarioState {
  final String message;
  ErrorMostrarUsuarioState(this.message);
  List<Object> get props => [message];
}

// ERROR EN TOKEN:

class ErrorTokenUsuarioState extends UsuarioState {
  final String message;
  ErrorTokenUsuarioState(this.message);
  List<Object> get props => [message];
}
