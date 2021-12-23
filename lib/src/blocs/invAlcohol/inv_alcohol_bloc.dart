import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/inv_alcohol_logic.dart';
import 'package:planning/src/models/item_model_inventario_alcohol.dart';

part 'inv_alcohol_event.dart';
part 'inv_alcohol_state.dart';

class EstatusBloc extends Bloc<InvAlcoholEvent, InvAlcoholState> {
  final ListaInventarioAlcoholLogic logic;
  EstatusBloc({@required this.logic}) : super(InvAlcoholInitial());

  @override
  Stream<InvAlcoholState> mapEventToState(
    InvAlcoholEvent event,
  ) async* {
    if (event is FechtInvAlcoholEvent) {
      yield LoadingInvAlcoholState();

      try {
        ItemModelInventarioAlcohol estatus =
            await logic.fetchInventarioAlcohol();
        yield MostrarInvAlcoholState(estatus);
      } on ListaInventarioAlcoholException {
        yield ErrorListaInvAlcoholState("Sin datos");
      } on TokenException {
        yield ErrorTokenInvAlcoholState("Sesión caducada");
      }
    } else if (event is CreateInvAlcoholEvent) {
      try {
        int idEstatusInvitado = await logic.createInventarioAlcohol(event.data);
        if (idEstatusInvitado == 0) {
          add(FechtInvAlcoholEvent());
        }
      } on CreateInventarioAlcoholException {
        yield ErrorCreateInvAlcoholState("No se pudo insertar");
      }
    } else if (event is UpdateInvAlcoholEvent) {
      bool response = await logic.updateInventarioAlcohol(event.data);
      ItemModelInventarioAlcohol model = event.cantidad;
      if (response) {
        for (int i = 0; i < model.results.length; i++) {
          if (model.results.elementAt(i).idInventarioAlcohol == event.id) {
            model.results.elementAt(i).addCantidad = event.data['cantidad'];
            model.results.elementAt(i).addMililitros = event.data['mililitros'];
            model.results.elementAt(i).addDescripcion =
                event.data['descripcion'];
          }
        }
      }
      yield MostrarInvAlcoholState(model);
    }
  }
}
