import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/proveedores_evento_logic.dart';
import 'package:weddingplanner/src/models/item_model_proveedores_evento.dart';
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
      print('Vamos a insertar ');
      try {
        print('Vamos a insertar ');
        int listaData = await logic.createProveedorEvento(event.data);
        // yield CreateProveedorEventoState(listaData);
      } catch (e) {
        print(e);
        yield ErrorCreateProveedorEventoState('No se pudo insertar');
      }
    } else if (event is DeleteProveedorEventosEvent) {
      print('Vamos a insertar ');
      try {
        print('Vamos a insertar ');
        int listaData = await logic.deleteProveedorEvento(event.data);
        // yield CreateProveedorEventoState(listaData);
      } catch (e) {
        print(e);
        yield ErrorDeleteProveedorEventoState('No se pudo insertar');
      }
    }
  }
}
