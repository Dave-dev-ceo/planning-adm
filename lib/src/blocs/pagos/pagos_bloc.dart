import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/pagos_logic.dart';
import 'package:weddingplanner/src/models/item_model_pagos.dart';

part 'pagos_event.dart';
part 'pagos_state.dart';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  final PagosLogic logic;
  PagosBloc({@required this.logic}) : super(PagosInitial());

  @override
  Stream<PagosState> mapEventToState(
    PagosEvent event,
  ) async* {
    if(event is SelectPagosEvent) {
      yield PagosLogging();

      try {
        ItemModelPagos pagos = await logic.selectPagos();
        yield PagosSelect(pagos);
      } on AutorizacionException {
        yield PagosErrorState('Error en select');
      } on TokenException {
        yield PagosTokenErrorState('Error token');
      }

    } else if(event is CrearPagosEvent) {
      yield PagosLogging();

      try {
        await logic.insertPagos(event.data);
        yield PagosCreateState();
      } on AutorizacionException {
        yield PagosErrorState('Error en insert');
      } on TokenException {
        yield PagosTokenErrorState('Error token');
      }


    } else if(event is UpdatePagosEvent) {
      yield PagosLogging();

      try {
        await logic.updatePagos(event.data);
        yield PagosUpdateState();
      } on AutorizacionException {
        yield PagosErrorState('Error en update');
      } on TokenException {
        yield PagosTokenErrorState('Error token');
      }

    } else if(event is DeletePagosEvent) {
      yield PagosLogging();

      try {
        await logic.deletePagos(event.id);
        ItemModelPagos pagos = await logic.selectPagos();
        yield PagosSelect(pagos);
      } on AutorizacionException {
        yield PagosErrorState('Error en delete');
      } on TokenException {
        yield PagosTokenErrorState('Error token');
      }

    } else if(event is SelectFormPagosEvent) {
      yield PagosLogging();

      try {
        ItemModelPagos proveedor = await logic.selectProveedor();
        ItemModelPagos servicio = await logic.selectServicios();
        yield PagosSelectFormState(proveedor,servicio);
      } on AutorizacionException {
        yield PagosErrorState('Error en select form');
      } on TokenException {
        yield PagosTokenErrorState('Error token');
      }

    } else if(event is SelectIdEvent) {
      yield PagosLogging();

      try {
        ItemModelPagos proveedor = await logic.selectProveedor();
        ItemModelPagos servicio = await logic.selectServicios();
        ItemModelPagos id = await logic.selectPagosId(event.id);
        yield PagosSelectId(id,proveedor,servicio);
      } on AutorizacionException {
        yield PagosErrorState('Error en select id');
      } on TokenException {
        yield PagosTokenErrorState('Error token');
      }

    }
  }
}
