import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/logic/add_contratos_logic.dart';
import 'package:planning/src/models/item_model_add_contratos.dart';

part 'add_contratos_event.dart';
part 'add_contratos_state.dart';

class AddContratosBloc extends Bloc<AddContratosEvent, AddContratosState> {
  final AddContratosLogic logic;
  AddContratosBloc({@required this.logic}) : super(AddContratosInitialState());

  @override
  Stream<AddContratosState> mapEventToState(
    AddContratosEvent event,
  ) async* {
    if (event is AddContratosSelect) {
      yield AddContratosLoggingState();
      try {
        ItemModelAddContratos autorizacion =
            await logic.selectContratosFromPlanner();
        yield SelectAddContratosState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if (event is AddContratosInsert) {
      yield AddContratosLoggingState();
      try {
        await logic.inserContrato(event.contrato);
        yield InsertAddContratosState();
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    }
  }
}
