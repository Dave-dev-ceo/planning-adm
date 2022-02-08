import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/roles_logic.dart';
import 'package:planning/src/models/model_form.dart';

part 'form_rol_event.dart';
part 'form_rol_state.dart';

class FormRolBloc extends Bloc<GetFormRolEvent, FormRolState> {
  final RolFormLogic logic;
  FormRolBloc({@required this.logic}) : super(FormRolInitial());

  @override
  Stream<FormRolState> mapEventToState(
    FormRolEvent event,
  ) async* {
    if (event is GetFormRolEvent) {
      yield LoadingMostrarFormRol();
      try {
        ItemModelFormRol rol =
            await logic.obtenerRolesForm(idRol: event.idRol0);
        yield MostrarFormRol(rol);
      } on ObtenerFormRolException {
        yield ErrorMostrarFormRol("Error al crear Usuario");
      } on TokenFormRolException {
        yield ErrorTokenFormRolState("Error de validación de token");
      }
    }
  }
}
