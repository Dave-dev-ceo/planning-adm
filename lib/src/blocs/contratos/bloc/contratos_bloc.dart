import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/add_contratos_logic.dart';
import 'package:planning/src/models/item_model_add_contratos.dart';

part 'contratos_event.dart';
part 'contratos_state.dart';

class ContratosDosBloc extends Bloc<ContratosEvent, ContratosState> {
  final AddContratosLogic logic;
  ContratosDosBloc({@required this.logic}) : super(ContratosInitial());

  @override
  Stream<ContratosState> mapEventToState(
    ContratosEvent event,
  ) async* {
    if (event is ContratosSelect) {
      yield ContratosLogging();
      try {
        ItemModelAddContratos autorizacion =
            await logic.selectContratosEvento();
        yield SelectContratoState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is UpdateValContratoEvent) {
      try {
        String valString = await logic.updateValContratos(event.data);
        yield UpdateValContratoState(valString);
        add(ContratosSelect());
      } on Exception {
        print('Error');
      }
    } else if (event is FectValContratoEvent) {
      try {
        String val = await logic.fetchValContratos(event.machote);
        yield FectValContratoState(val);
      } on Exception {
        print('Error');
      }
    }
  }
}
