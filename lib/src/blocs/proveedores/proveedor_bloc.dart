import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/proveedores_logic.dart';
import 'package:weddingplanner/src/models/item_model_proveedores.dart';

part 'proveedor_event.dart';
part 'proveedor_state.dart';

class ProveedorBloc extends Bloc<ProveedorEvent, ProveedorState> {
  final FetchProveedoresLogic logic;
  ProveedorBloc({@required this.logic}) : super(ProveedorInitial());

  @override
  Stream<ProveedorState> mapEventToState(
    ProveedorEvent event,
  ) async* {
    if (event is FechtProveedorEvent) {
      yield LoadingProveedorState();
      try {
        ItemModelProveedores proveedor = await logic.fetchProveedor();
        yield MostrarProveedorState(proveedor);
      } catch (e) {
        print(e);
        yield ErrorCreateProveedorState('No se pudo insertar');
      }
    } else if (event is CreateProveedorEvent) {
      try {
        int proveedor = await logic.createProveedor(event.data);
        if (proveedor == 0) {
          add(FechtProveedorEvent());
          add(FechtSevicioByProveedorEvent());
        }
      } catch (e) {
        print(e);
        yield ErrorCreateProveedorState('No se pudo insertar');
      }
    } else if (event is FechtSevicioByProveedorEvent) {
      try {
        ItemModelServicioByProv servicios = await logic.fetchServicioByProv();
        yield MostrarSevicioByProveedorState(servicios);
      } catch (e) {
        print(e);
        yield ErrorCreateProveedorState('No se pudo insertar');
      }
    } else if (event is DeleteServicioProvEvent) {
      try {
        int service = await logic.deleteServicioProv(event.idServicio);
        if (service == 0) {
          print('Si actualizo la lista de eliminar');
          add(FechtProveedorEvent());
          add(FechtSevicioByProveedorEvent());
        }
      } catch (e) {}
    } else if (event is UpdateProveedor) {
      try {
        final response = await logic.updateProveedor(event.proveedor);
        if (response == 'Ok') {
          add(FechtProveedorEvent());
          add(FechtSevicioByProveedorEvent());
        }
      } catch (e) {}
    }
  }
}
