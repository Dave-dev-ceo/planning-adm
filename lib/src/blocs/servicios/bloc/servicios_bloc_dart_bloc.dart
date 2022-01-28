import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/servicios_logic.dart';
import 'package:planning/src/models/item_model_servicios.dart';

part 'servicios_bloc_dart_event.dart';
part 'servicios_bloc_dart_state.dart';

class ServiciosBloc extends Bloc<ServiciosEvent, ServiciosState> {
  final ServiciosLogic logic;
  ServiciosBloc({@required this.logic}) : super(ServiciosInitial());

  @override
  Stream<ServiciosState> mapEventToState(
    ServiciosEvent event,
  ) async* {
    if (event is FechtServiciosEvent) {
      yield LoadingServiciosState();
      try {
        ItemModuleServicios listServicios = await logic.fetchServicios();
        yield MostrarServiciosState(listServicios);
      } on ServiciosException {
        yield ErrorMostrarServiciosState('Sin articulos');
      } on TokenException {
        yield ErrorMostrarServiciosState('Sesión caducada');
      }
    } else if (event is CreateServiciosEvent) {
      try {
        int service = await logic.createServicio(event.data);
        if (service == 0) {
          add(FechtServiciosEvent());
        }
      } catch (e) {
        print(e);
        yield ErrorMostrarServiciosState('No se pudo insertar');
      }
    } else if (event is UpdateServicioEvent) {
      try {
        int service = await logic.editarServicio(event.datos);
        if (service == 0) {
          add(FechtServiciosEvent());
        }
      } catch (e) {
        print(e);
        yield ErrorMostrarServiciosState('No se pudo insertar');
      }
    } else if (event is DeleteServicioEvent) {
      try {
        int service = await logic.deleteDetallaLista(event.idServicio);
        if (service == 0) {
          add(FechtServiciosEvent());
        }
      } catch (e) {}
    } else if (event is FechtServiciosByProveedorEvent) {
      try {
        ItemModuleServicios service =
            await logic.fetchServiciosByProoveedor(event.id_proveedor);
        yield MostrarServiciosByProveedorState(service);
      } on ServiciosException {
        yield ErrorMostrarServiciosState('Sin articulos');
      } on TokenException {
        yield ErrorMostrarServiciosState('Sesión caducada');
      } catch (e) {}
    }
  }
}
