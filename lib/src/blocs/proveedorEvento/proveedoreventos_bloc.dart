import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/proveedores_evento_logic.dart';
import 'package:planning/src/models/item_model_proveedores_evento.dart';
part 'proveedoreventos_event.dart';
part 'proveedoreventos_state.dart';

class ProveedoreventosBloc
    extends Bloc<ProveedoreventosEvent, ProveedoreventosState> {
  final FetchProveedoresEventoLogic logic;
  ProveedoreventosBloc({@required this.logic})
      : super(ProveedoreventosInitial());

  @override
  Stream<ProveedoreventosState> mapEventToState(
    ProveedoreventosEvent event,
  ) async* {
    if (event is FechtProveedorEventosEvent) {
      yield LoadingProveedorEvento();
      try {
        ItemModelProveedoresEvento provEvento =
            await logic.fetchProveedorEvento();
        yield MostrarProveedorEventoState(provEvento);
      } catch (e) {
        yield ErrorCreateProveedorEventoState('Error');
      }
    } else if (event is CreateProveedorEventosEvent) {
      try {
        await logic.createProveedorEvento(event.data);
        // yield CreateProveedorEventoState(listaData);
      } catch (e) {
        yield ErrorCreateProveedorEventoState('No se pudo insertar');
      }
    } else if (event is DeleteProveedorEventosEvent) {
      try {
        await logic.deleteProveedorEvento(event.data);
        // yield CreateProveedorEventoState(listaData);
      } catch (e) {
        yield ErrorDeleteProveedorEventoState('No se pudo insertar');
      }
    } else if (event is UpdateProveedorEventosEvent) {
      try {
        await logic.updateProveedorEvento(event.data);
      } catch (e) {
        yield ErrorCreateProveedorEventoState('No se pudo actualizar');
      }
    }
  }
}
