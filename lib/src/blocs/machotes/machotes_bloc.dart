import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/machotes_logic.dart';
import 'package:planning/src/models/item_model_machotes.dart';

part 'machotes_event.dart';
part 'machotes_state.dart';

class MachotesBloc extends Bloc<MachotesEvent, MachotesState> {
  final ListaMachotesLogic logic;
  MachotesBloc({@required this.logic}) : super(MachotesInitial());

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
        yield ErrorUpdateMachotesState("No de actualizo");
      }
    } else if (event is UpdateNombreMachoteEvent) {
      try {
        final data =
            await logic.updateNameMachote(event.idMachote, event.nuevoombre);
        add(FechtMachotesEvent());
      } catch (e) {}
    } else if (event is EliminarMachoteEvent) {
      try {
        final data = await logic.eliminarMachote(event.idMachote);
        add(FechtMachotesEvent());
      } catch (e) {}
    }
  }
}
