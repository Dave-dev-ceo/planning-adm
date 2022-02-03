import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/historial_pagos/historial_pagos_logic.dart';
import 'package:planning/src/models/historialPagos/historial_pagos_model.dart';

part 'historialpagos_event.dart';
part 'historialpagos_state.dart';

class HistorialPagosBloc
    extends Bloc<HistorialPagosEvent, HistorialPagosState> {
  final HistorialPagosLogic logic;

  HistorialPagosBloc({this.logic}) : super(HistorialPagosInitial());

  @override
  Stream<HistorialPagosState> mapEventToState(
      HistorialPagosEvent event) async* {
    if (event is MostrarHistorialPagosEvent) {
      yield LoadingHistorialPagosState();

      try {
        final data = await logic.getPagosByEvent();

        yield MostrarHistorialPagosState(data);
      } on PagosException {}
    } else if (event is AgregarPagosEvent) {
      try {
        final resp = await logic.agregarPagoEvento(event.pago);

        yield PagoAgregadostate(resp);

        add(MostrarHistorialPagosEvent());
      } catch (e) {}
    } else if (event is EditarPagosEvent) {
      try {
        final resp = await logic.editarPagoEvento(event.pago);

        yield PagoEditadostate(resp);
        add(MostrarHistorialPagosEvent());
      } catch (e) {}
    } else if (event is EliminarPagoEvent) {
      try {
        final resp = await logic.eliminarPagoEvento(event.idPago);

        yield EliminarPagoState(resp);
        add(MostrarHistorialPagosEvent());
      } catch (e) {}
    }
  }
}
