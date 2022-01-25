import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/archivos_proveedores_logic.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';
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
        print('EntreAqui traer archivos');
        yield MostrarArchivoProvServState(proveedor);
      } catch (e) {
        print('error obtener datos');

        print(e);
        yield ErrorMostrarArchivoProvServState('No se pudo insertar');
      }
    } else if (event is CreateArchivoProvServEvent) {
      try {
        await logic.createArchivos(event.data);
        //add(FechtArchivoProvServEvent(int.parse(event.data['id_proveedor']), 0));
        add(FechtArchivoProvServEvent(
            (event.data['id_proveedor'].runtimeType is int)
                ? event.data['id_proveedor']
                : int.parse(event.data['id_proveedor']),
            (event.data['id_servicio'] == null)
                ? 0
                : (event.data['id_servicio'].runtimeType is int)
                    ? event.data['id_proveedor']
                    : int.parse(event.data['id_proveedor']),
            false));
      } catch (e) {
        print('error crear evento');
        print(e);
        yield ErrorCreateArchivoProvServState('No se pudo insertar');
      }
    } else if (event is DeleteArchivoEvent) {
      try {
        int service = await logic.deleteArchivo(event.idArchivo);
        if (service == 0) {
          add(FechtArchivoProvServEvent(
              event.idProveedor, event.idServicio, false));
        }
      } catch (e) {}
    }
  }
}
