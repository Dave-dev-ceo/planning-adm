import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/machotes_logic.dart';
import 'package:planning/src/models/item_model_machotes.dart';

part 'machotes_event.dart';
part 'machotes_state.dart';

class MachotesBloc extends Bloc<MachotesEvent, MachotesState> {
  final ListaMachotesLogic logic;
  MachotesBloc({required this.logic}) : super(MachotesInitial());

  @override
  Stream<MachotesState> mapEventToState(
    MachotesEvent event,
  ) async* {
    if (event is FechtMachotesEvent) {
      yield LoadingMachotesState();

      try {
        ItemModelMachotes machotes = await logic.fetchMachotes();
        yield MostrarMachotesState(machotes);
      } on ListaMachotesException {
        yield ErrorListaMachotesState("Sin machotes");
      } on TokenException {
        yield ErrorTokenMachotesState("Sesión caducada");
      }
    } else if (event is CreateMachotesEvent) {
      try {
        int idMachotes = await logic.createMachotes(event.data);
        if (idMachotes == 0) {
          add(FechtMachotesEvent());
        }
      } on CreateMachotesException {
        yield ErrorCreateMachotesState("No se pudo insertar");
      }
    } else if (event is UpdateMachotesEvent) {
      try {
        bool response = await logic.updateMachotes(event.data);

        if (response) {
          add(FechtMachotesEvent());
        }
      } on UpdateMachotesException {
        yield ErrorUpdateMachotesState("No se actualizó");
      }
    } else if (event is UpdateNombreMachoteEvent) {
      try {
        await logic.updateNameMachote(event.idMachote, event.nuevoombre);
        add(FechtMachotesEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else if (event is EliminarMachoteEvent) {
      try {
        await logic.eliminarMachote(event.idMachote);
        add(FechtMachotesEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}
