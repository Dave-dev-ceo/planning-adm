import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/estatus_logic.dart';
import 'package:weddingplanner/src/logic/mesas_asignadas_logic/mesas_asignadas_logic.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';

part 'mesas_event.dart';
part 'mesas_state.dart';

class MesasAsignadasBloc
    extends Bloc<MesasAsignadasEvent, MesasAsignadasState> {
  final MesasAsignadasLogic logic;
  MesasAsignadasBloc({@required this.logic}) : super(MesasInitial());

  @override
  Stream<MesasAsignadasState> mapEventToState(
      MesasAsignadasEvent event) async* {
    if (event is MostrarMesasAsignadasEvent) {
      yield LoadingMesasAsignadasState();
      try {
        List<MesasModel> mesas = await logic.getMesasAsignadas();
        yield MostrarMesasAsignadasState(mesas);
      } on MesasAsignadasException {
        yield ErrorMesasAsignadasState("Sin Mesas Asignadas");
      } on TokenException {
        yield ErrorTokenMesasAsignadasState(message: 'Sesion Caducada');
      }
    }
  }
}
