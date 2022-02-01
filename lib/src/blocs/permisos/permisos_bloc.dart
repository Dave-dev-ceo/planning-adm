import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/permisos_logic.dart';
import 'package:planning/src/models/model_perfilado.dart';

part 'permisos_event.dart';
part 'permisos_state.dart';

class PermisosBloc extends Bloc<PermisosEvent, PermisosState> {
  final PerfiladoLogic logic;
  PermisosBloc({@required this.logic}) : super(PermisosInitial());

  @override
  Stream<PermisosState> mapEventToState(
    PermisosEvent event,
  ) async* {
    if (event is obtenerPermisosEvent) {
      yield LoadingPermisos();

      try {
        ItemModelPerfil permisos = await logic.obtenerPermisosUsuario();
        yield PermisosOk(permisos);
      } on PermisosException {
        yield ErrorPermisos("Sin permisos");
      } on TokenPermisosException {
        yield ErrorTokenPermisos("Sesión caducada");
      }
    }
  }

  @override
  void onTransition(Transition<PermisosEvent, PermisosState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
