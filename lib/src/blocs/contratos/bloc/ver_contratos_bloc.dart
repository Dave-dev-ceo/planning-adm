import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/add_contratos_logic.dart';

part 'ver_contratos_event.dart';
part 'ver_contratos_state.dart';

class VerContratosBloc extends Bloc<VerContratosEvent, VerContratosState> {
  final AddContratosLogic logic;
  VerContratosBloc({@required this.logic}) : super(VerContratosInitial());

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
        await logic.updateContratoEvento(event.id, event.archivo);
        yield VerContratosSubir();
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is VerContrato) {
      yield VerContratosLoggin();

      try {
        String pdf = await logic.fetchContratosPdf({'machote': event.archivo});
        yield VerContratosVer(pdf);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is VerContratoSubido) {
      yield VerContratosLoggin();

      try {
        yield VerContratosVer(event.archivo);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is DescargarContrato) {
      yield VerContratosLoggin();

      try {
        String pdf = await logic.fetchContratosPdf({'machote': event.archivo});
        yield DescargarContratoState(event.nombre, pdf);
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
          'clave': event.clave
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
