import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/logic/add_contratos_logic.dart';

part 'ver_contratos_event.dart';
part 'ver_contratos_state.dart';

class VerContratosBloc extends Bloc<VerContratosEvent, VerContratosState> {
  final AddContratosLogic logic;
  VerContratosBloc({required this.logic}) : super(VerContratosInitial());

  @override
  Stream<VerContratosState> mapEventToState(
    VerContratosEvent event,
  ) async* {
    if (event is BorrarContrato) {
      yield VerContratosLoggin();

      try {
        await logic.borrarContratoEvento(event.id);
        yield VerContratosBorrar();
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is SubirContrato) {
      yield VerContratosLoggin();

      try {
        // metodo update
        await logic.updateContratoEvento(
            event.id, event.archivo, event.tipoDoc, event.tipoMime);
        yield VerContratosSubir();
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is VerContrato) {
      yield VerContratosLoggin();

      try {
        String? pdf = await logic
            .fetchContratosPdf({'id_contrato': event.idContrato.toString()});
        yield VerContratosVer(pdf, event.tipoMime, event.tipoDoc);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      } catch (e) {
        yield AutorizacionErrorState('Error en consulta');
      }
    } else if (event is VerContratoSubido) {
      yield VerContratosLoggin();

      try {
        String? archivo =
            await logic.obtenerContratoById({'id_contrato': event.idContrato});
        yield VerContratosVer(archivo, event.tipoMime, event.tipoDoc);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is DescargarArchivoSubidoEvent) {
      yield VerContratosLoggin();

      try {
        String? archivo =
            await logic.obtenerContratoById({'id_contrato': event.idContrato});
        yield DescargarArchivoSubidoState(
            archivo, event.tipoMime, event.nombre);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is VerContratoSubidoEvent) {
      yield VerContratosLoggin();

      try {
        String? archivo = await logic
            .obtenerContratoSubidoById({'id_contrato': event.idContrato});

        yield VerContratoSubidoState(archivo, event.tipoMime, event.nombre);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is DescargarContratoSubidoEvent) {
      yield VerContratosLoggin();

      try {
        String? archivo = await logic
            .obtenerContratoSubidoById({'id_contrato': event.idContrato});

        yield DescargarContratoSubidoState(
            archivo, event.tipoMime, event.nombre);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is DescargarContrato) {
      yield VerContratosLoggin();

      try {
        String? pdf = await logic
            .fetchContratosPdf({'id_contrato': event.idContrato.toString()});
        yield DescargarContratoState(event.nombre, pdf, event.tipoMime);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is CrearContrato) {
      yield VerContratosLoggin();

      try {
        Map data = {
          'id_machote': '0',
          'titulo': event.nombre,
          'archivo': event.archivo,
          'clave': event.clave,
          'tipo_doc': event.tipoDoc,
          'tipo_mime': event.tipoMime
        };
        await logic.inserContrato(data);
        yield CrearContratoState();
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    }
  }
}
