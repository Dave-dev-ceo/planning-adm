import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
      try {
        ItemModelArchivoProvServ archivo =
            await logic.fetchArchivosById(event.idArchivo);
        yield MostrarArchivoByIdState(archivo);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        yield ErrorArchivoByIdState('No se pudo insertar');
      }
    } else if (event is FechtArchivoEspecialByIdEvent) {
      try {
        ItemModelArchivoEspecial archivo =
            await logic.fetchArchivosEspecialById(event.idArchivo);
        yield MostrarArchivoEspecialByIdState(archivo);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        yield ErrorArchivoByIdState('No se pudo insertar');
      }
    }
  }
}
