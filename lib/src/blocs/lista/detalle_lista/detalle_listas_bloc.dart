import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/detalle_listas_logic.dart';
import 'package:planning/src/models/item_model_detalle_listas.dart';
part 'detalle_listas_event.dart';
part 'detalle_listas_state.dart';

class DetalleListasBloc extends Bloc<DetalleListasEvent, DetalleListasState> {
  final DetallesListasLogic logic;
  DetalleListasBloc({@required this.logic}) : super(DetalleListasInitial());

  @override
  Stream<DetalleListasState> mapEventToState(DetalleListasEvent event) async* {
    if (event is FechtDetalleListaEvent) {
      yield LoadingDetalleListasState();
      try {
        ItemModelDetalleListas detListas =
            await logic.fetchDetalleListas(event.idLista);
        yield MostrarDetalleListasState(detListas);
      } on DetalleListasException {
        yield ErrorMostrarDetalleListasState('Sin articulos');
      } on TokenException {
        print('Error');
      }
    } else if (event is CreateDetalleListasEvent) {
      try {
        int idArticulo = await logic.createDetalleLista(event.data);
        if (idArticulo == 0) {
          add(FechtDetalleListaEvent(int.parse(event.data['id_lista'])));
        }
      } catch (e) {
        print(e);
        yield ErrorCreateDetalleListasrState('No se pudo insertar');
      }
    } else if (event is DeleteDetalleListaEvent) {
      try {
        int idArticulo = await logic.deleteDetallaLista(event.idDetalleLista);
        print('idArticulo');
        print(idArticulo);
        if (idArticulo == 0) {
          print('Si actualizo la lista de eliminar');
          add(FechtDetalleListaEvent(event.idLista));
        }
      } catch (e) {}
    } else if (event is UpdateDetalleListasEvent) {
      try {
        int idArticulo = await logic.editarDetalleLista(event.data);
        if (idArticulo == 0) {
          add(FechtDetalleListaEvent(int.parse(event.data['id_lista'])));
        }
      } catch (e) {
        print(e);
        yield ErrorCreateDetalleListasrState('No se pudo insertar');
      }
    } else if (event is CreateListasEvent) {
      try {
        int listaData = await logic.createLista(event.data);
        if (listaData == 0) {
          add(FechtDetalleListaEvent(listaData));
        }
        print('Este es mi id xd  $listaData');
        yield CreateListasState(listaData);
      } catch (e) {
        print(e);
        yield ErrorCreateDetalleListasrState('No se pudo insertar');
      }
    } else if (event is UpdateListasEvent) {
      try {
        int idArticulo = await logic.editarLista(event.data);
        if (idArticulo == 0) {
          add(FechtDetalleListaEvent(int.parse(event.data['id_lista'])));
        }
      } catch (e) {
        print(e);
        yield ErrorCreateDetalleListasrState('No se pudo insertar');
      }
    }
  }
}
