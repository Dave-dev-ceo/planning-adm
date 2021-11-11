import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/archivos_proveedores_logic.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';

part 'view_archivos_event.dart';
part 'view_archivos_state.dart';

class ViewArchivosBloc extends Bloc<ViewArchivosEvent, ViewArchivosState> {
  final LogicArchivoProveedores logic;
  ViewArchivosBloc({@required this.logic}) : super(ViewArchivosInitial());

  @override
  Stream<ViewArchivosState> mapEventToState(
    ViewArchivosEvent event,
  ) async* {
    if (event is FechtArchivoByIdEvent) {
      print('Entro al bloc');
      try {
        ItemModelArchivoProvServ archivo =
            await logic.fetchArchivosById(event.id_archivo);
        yield MostrarArchivoByIdState(archivo);
      } catch (e) {
        print(e);
        yield ErrorArchivoByIdState('No se pudo insertar');
      }
    }
  }
}
