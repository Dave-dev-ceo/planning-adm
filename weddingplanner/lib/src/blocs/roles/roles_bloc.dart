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
        ItemModelRoles roles = await logic.obtenerRolesPorPlanner();
        yield MostrarRoles(roles);
      } on RolesException {
        yield ErrorObtenerRoles("Sin permisos");
      } on TokenRolesException {
        yield ErrorTokenRoles("Sesión caducada");
      }
    }
  }
}
