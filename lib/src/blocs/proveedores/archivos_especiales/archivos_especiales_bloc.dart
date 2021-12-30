import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:planning/src/logic/archivos_proveedores_logic.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';

part 'archivos_especiales_event.dart';
part 'archivos_especiales_state.dart';

class ArchivosEspecialesBloc
    extends Bloc<ArchivosEspecialesEvent, ArchivosEspecialesState> {
  final LogicArchivoProveedores logic;
  ArchivosEspecialesBloc({@required this.logic})
      : super(ArchivosEspecialesInitial());
  @override
  Stream<ArchivosEspecialesState> mapEventToState(
    ArchivosEspecialesEvent event,
  ) async* {
    if (event is FechtArchivoEspecialEvent) {
      yield LoadingArchivoEspecialState();
      try {
        ItemModelArchivoEspecial proveedor = await logic.fetchArchivosProvEvent(
            event.id_proveedor, event.id_evento);
        yield MostrarArchivoProvEventState(proveedor);
      } catch (e) {
        yield ErrorMostrarArchivEspecialState('No se pudo insertar');
      }
    } else if (event is DeleteArchivoEspecialEvent) {
      try {
        int service = await logic.deleteArchivoEspecial(event.idArchivo);
        add(FechtArchivoEspecialEvent(event.idProveedor, event.idEvento));
      } catch (e) {}
    } else if (event is CreateArchivoEspecialEvent) {
      try {
        int proveedor = await logic.createArchivosEspecial(event.data);
        add(FechtArchivoEspecialEvent(int.parse(event.data['id_proveedor']),
            int.parse(event.data['id_evento'])));
      } catch (e) {
        print(e);
      }
    }
  }
}
