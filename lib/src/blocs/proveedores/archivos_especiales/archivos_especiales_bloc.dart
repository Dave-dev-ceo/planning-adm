import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/archivos_proveedores_logic.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';

part 'archivos_especiales_event.dart';
part 'archivos_especiales_state.dart';

class ArchivosEspecialesBloc
    extends Bloc<ArchivosEspecialesEvent, ArchivosEspecialesState> {
  final LogicArchivoProveedores logic;
  ArchivosEspecialesBloc({required this.logic})
      : super(ArchivosEspecialesInitial());
  @override
  Stream<ArchivosEspecialesState> mapEventToState(
    ArchivosEspecialesEvent event,
  ) async* {
    if (event is FechtArchivoEspecialEvent) {
      yield LoadingArchivoEspecialState();
      try {
        ItemModelArchivoEspecial proveedor = await logic.fetchArchivosProvEvent(
            event.idProveedor, event.idEvento);
        yield MostrarArchivoProvEventState(proveedor);
      } catch (e) {
        yield ErrorMostrarArchivEspecialState('No se pudo insertar');
      }
    } else if (event is DeleteArchivoEspecialEvent) {
      try {
        await logic.deleteArchivoEspecial(event.idArchivo);
        add(FechtArchivoEspecialEvent(event.idProveedor, event.idEvento));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else if (event is CreateArchivoEspecialEvent) {
      try {
        await logic.createArchivosEspecial(event.data);

        add(
          FechtArchivoEspecialEvent(
            (event.data['id_proveedor'].runtimeType == String)
                ? int.parse(event.data['id_proveedor'])
                : event.data['id_proveedor'],
            (event.data['id_evento'].runtimeType == String)
                ? int.parse(event.data['id_evento'])
                : event.data['id_evento'],
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}
