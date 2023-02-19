part of 'roles_bloc.dart';

@immutable
abstract class RolesEvent {}

class ObtenerRolesEvent extends RolesEvent {
  ObtenerRolesEvent();
}

class ObtenerRolesPlannerEvent extends RolesEvent {
  ObtenerRolesPlannerEvent();
}
