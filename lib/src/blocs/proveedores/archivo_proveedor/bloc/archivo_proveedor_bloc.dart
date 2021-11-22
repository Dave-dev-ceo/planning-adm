import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/archivos_proveedores_logic.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';
import 'package:planning/src/models/item_model_proveedores.dart';

part 'archivo_proveedor_event.dart';
part 'archivo_proveedor_state.dart';

class ArchivoProveedorBloc
    extends Bloc<ArchivoProveedorEvent, ArchivoProveedorState> {
  final LogicArchivoProveedores logic;
  ArchivoProveedorBloc({@required this.logic})
      : super(ArchivoProveedorInitial());

  @override
  Stream<ArchivoProveedorState> mapEventToState(
    ArchivoProveedorEvent event,
  ) async* {
    if (event is FechtArchivoProvServEvent) {
      yield LoadingArchivoProveedorState();
      try {
        ItemModelArchivoProvServ proveedor = await logic.fetchArchivosProvServ(
            event.id_proveedor, event.id_servicio);
        yield MostrarArchivoProvServState(proveedor);
      } catch (e) {
        print(e);
        yield ErrorMostrarArchivoProvServState('No se pudo insertar');
      }
    } else if (event is CreateArchivoProvServEvent) {
      try {
        int proveedor = await logic.createArchivos(event.data);
        print(proveedor);
        if (proveedor == 0) {
          // add(FechtArchivoProvServEvent(
          //     int.parse(event.data['id_proveedor']), 0));

          if (event.data['id_servicio'] == 'null') {
            add(FechtArchivoProvServEvent(
                int.parse(event.data['id_proveedor']), 0));
          } else if (event.data['id_proveedor'] == 'null') {
            add(FechtArchivoProvServEvent(
                0, int.parse(event.data['id_servicio'])));
          }
        }
      } catch (e) {
        print(e);
        yield ErrorCreateArchivoProvServState('No se pudo insertar');
      }
    } else if (event is DeleteArchivoEvent) {
      try {
        int service = await logic.deleteArchivo(event.idArchivo);
        if (service == 0) {
          add(FechtArchivoProvServEvent(event.idProveedor, event.idServicio));
        }
      } catch (e) {}
    }
  }
}
