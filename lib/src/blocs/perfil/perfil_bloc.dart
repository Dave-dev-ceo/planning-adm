import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/perfil_logic.dart';
import 'package:planning/src/models/item_model_perfil.dart';
import 'package:planning/src/models/perfil/perfil_planner_model.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  final PerfilLogic logic;
  PerfilBloc({@required this.logic}) : super(PerfilInitial());

  @override
  Stream<PerfilState> mapEventToState(
    PerfilEvent event,
  ) async* {
    if (event is SelectPerfilEvent) {
      yield PerfilLogging();

      try {
        ItemModelPerfil perfil = await logic.selectPerfil();
        yield PerfilSelect(perfil);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is InsertPerfilEvent) {
      yield PerfilLogging();

      try {
        await logic.insertPerfil(event.perfil);
        ItemModelPerfil perfil = await logic.selectPerfil();
        yield PerfilSelect(perfil);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is PerfilPlannerEvent) {
      yield PerfilLogging();

      try {
        final data = await logic.getPerfilPlanner();
        yield PerfilPlannerState(data);
      } catch (e) {
        print(e);
      }
    }
  }
}
