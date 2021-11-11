import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/roles_logic.dart';
import 'package:weddingplanner/src/models/model_roles.dart';

part 'roles_event.dart';
part 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final RolesPlannerLogic logic;
  RolesBloc({@required this.logic}) : super(RolesInitial());

  @override
  Stream<RolesState> mapEventToState(
    RolesEvent event,
  ) async* {
    if (event is ObtenerRolesEvent) {
      yield LoadingRoles();

      try {
        ItemModelRoles roles = await logic.obtenerRolesSelect();
        yield MostrarRoles(roles);
      } on RolesException {
        yield ErrorObtenerRoles("Error al obtener Roles");
      } on TokenRolesException {
        yield ErrorTokenRoles("Sesión caducada");
      }
    } else if (event is ObtenerRolesPlannerEvent) {
      yield LoadingRolesPlanner();
      try {
        ItemModelRoles roles = await logic.obtenerRolesPorPlanner();
        yield MostrarRolesPlanner(roles);
      } on RolesPlannerException {
        yield ErrorObtenerRolesPlanner("Error al obtener lista de Roles");
      } on TokenRolesException {
        yield ErrorTokenRolesPlanner("Sesión caducada");
      }
    }
  }
}
