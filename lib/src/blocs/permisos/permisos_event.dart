part of 'permisos_bloc.dart';

@immutable
abstract class PermisosEvent {}

class ObtenerPermisosEvent extends PermisosEvent {}

class PermisosSinConexion extends PermisosEvent {
  final ItemModelPerfil permisos;

  PermisosSinConexion(this.permisos);
}
