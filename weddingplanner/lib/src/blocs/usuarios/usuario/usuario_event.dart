part of 'usuario_bloc.dart';

@immutable
abstract class UsuarioEvent {}

class CrearUsuarioEvent extends UsuarioEvent {
  final Map<String, dynamic> jsonUsuario;
  CrearUsuarioEvent(this.jsonUsuario);
  Map<String, dynamic> get data => this.jsonUsuario;
}

class EditarUsuarioEvent extends UsuarioEvent {
  final Map<String, dynamic> jsonUsuario;
  EditarUsuarioEvent(this.jsonUsuario);
  Map<String, dynamic> get data => this.jsonUsuario;
}

class FetchUsuarioPorIdEvent extends UsuarioEvent {
  final String idUsr;
  FetchUsuarioPorIdEvent(this.idUsr);
  String get idUsuario => this.idUsr;
}
