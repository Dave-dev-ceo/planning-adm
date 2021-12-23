import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/roles_logic.dart';
import 'package:planning/src/models/model_roles.dart';

part 'rol_event.dart';
part 'rol_state.dart';

class RolBloc extends Bloc<RolEvent, RolState> {
  final RolLogic logic;
  RolBloc({@required this.logic}) : super(RolInitial());

  @override
  Stream<RolState> mapEventToState(
    RolEvent event,
  ) async* {
    // Crear usuario
    if (event is CrearRolEvent) {
      yield LoadingCrearRolState();
      try {
        ItemModelRol rol = await logic.crearRol(event.data);
        yield RolCreadoState(new ItemModelRol(rol.result));
      } on CrearRolException {
        yield ErrorCrearRolState("Error al crear rol");
      } on TokenRolException {
        yield ErrorTokenRolState("Error de validación de token");
      }
    } // Editar usuario
    if (event is EditarRolEvent) {
      yield LoadingEditarRolState();
      try {
        ItemModelRol rol = await logic.editarRol(event.data);
        yield RolEditadoState(new ItemModelRol(rol.result));
      } on EditarRolException {
        yield ErrorEditarRolState("Error al editar rol");
      } on TokenRolException {
        yield ErrorTokenRolState("Error de validación de token");
      }
    }
  }
}
