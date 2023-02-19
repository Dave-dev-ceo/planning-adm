part of 'usuarios_bloc.dart';

@immutable
abstract class UsuariosState {}

class UsuariosInitialState extends UsuariosState {}

class LoadingUsuariosState extends UsuariosState {}

class MostrarUsuariosState extends UsuariosState {
  final ItemModelUsuarios? usuarios;

  MostrarUsuariosState(this.usuarios);

  ItemModelUsuarios? get props => usuarios;
}

class ErrorMostrarUsuariosState extends UsuariosState {
  final String message;

  ErrorMostrarUsuariosState(this.message);

  List<Object> get props => [message];
}

// ERROR EN TOKEN:
class ErrorTokenUsuariosState extends UsuariosState {
  final String message;

  ErrorTokenUsuariosState(this.message);

  List<Object> get props => [message];
}
