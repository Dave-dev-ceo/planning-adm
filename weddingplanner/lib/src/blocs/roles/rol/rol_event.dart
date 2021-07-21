part of 'rol_bloc.dart';

@immutable
abstract class RolEvent {}

class CrearRolEvent extends RolEvent {
  final Map<String, dynamic> jsonRol;
  CrearRolEvent(this.jsonRol);
  Map<String, dynamic> get data => this.jsonRol;
}

class EditarRolEvent extends RolEvent {
  final Map<String, dynamic> jsonRol;
  EditarRolEvent(this.jsonRol);
  Map<String, dynamic> get data => this.jsonRol;
}

class ObtenerRolPorIdEvent extends RolEvent {
  final String idRol;
  ObtenerRolPorIdEvent(this.idRol);
  String get id_Rol => this.idRol;
}
