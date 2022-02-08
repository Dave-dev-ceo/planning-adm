part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioState {}

class UsuarioInitial extends UsuarioState {}

// ESTADOS DE ALTA DE USUARIO

class LoadingCrearUsuarioState extends UsuarioState {}

class UsuarioCreadoState extends UsuarioState {
  final ItemModelUsuario usuario;
  UsuarioCreadoState(this.usuario);
  ItemModelUsuario get data => usuario;
}

class ErrorCrearUsuarioState extends UsuarioState {
  final String message;
  ErrorCrearUsuarioState(this.message);

  List<Object> get props => [message];
}

// ESTADOS DE EDICION DE USUARIO

class LoadingEditarUsuarioState extends UsuarioState {}

class UsuarioEditadoState extends UsuarioState {
  final ItemModelUsuario usuario;
  UsuarioEditadoState(this.usuario);
  ItemModelUsuario get data => usuario;
}

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
