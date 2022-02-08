part of 'rol_bloc.dart';

@immutable
abstract class RolEvent {}

class CrearRolEvent extends RolEvent {
  final Map<String, dynamic> jsonRol;
  CrearRolEvent(this.jsonRol);
  Map<String, dynamic> get data => jsonRol;
}

class EditarRolEvent extends RolEvent {
  final Map<String, dynamic> jsonRol;
  EditarRolEvent(this.jsonRol);
  Map<String, dynamic> get data => jsonRol;
}

class ObtenerRolPorIdEvent extends RolEvent {
  final String idRol;
  ObtenerRolPorIdEvent(this.idRol);
  String get idrol => idRol;
}
