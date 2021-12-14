import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/estatus_logic.dart';
import 'package:planning/src/logic/mesas_logic/mesa_logic.dart';
import 'package:planning/src/models/mesa/mesas_model.dart';

part 'mesas_event.dart';
part 'mesas_state.dart';

class MesasBloc extends Bloc<MesasEvent, MesasState> {
  final MesasLogic logic;
  MesasBloc({@required this.logic}) : super(MesasInitial());

  @override
  Stream<MesasState> mapEventToState(MesasEvent event) async* {
    if (event is MostrarMesasEvent) {
      yield LoadingMesasState();
      try {
        List<MesaModel> mesas = await logic.getMesas();
        yield MostrarMesasState(mesas);
      } on MesasAsignadasException {
        yield ErrorMesasState("No se encontraron mesas");
      } on TokenException {
        yield ErrorTokenMesasState(message: 'Sesion Caducada');
      }
    } else if (event is CreateMesasEvent) {
      try {
        yield CreateMesasState();
        String data = await logic.createMesas(event.mesas);
        if (data == 'Ok') {
          add(MostrarMesasEvent());
        }
        yield CreatedMesasState(data);
      } catch (e) {
        yield CreatedMesasState(e);
      }
    } else if (event is EditMesaEvent) {
      try {
        final data = await logic.updateMesa(event.mesaToEdit);

        yield MesasEditedState(data);
        add(MostrarMesasEvent());
      } catch (e) {
        print(e);
      }
    }
  }
}
