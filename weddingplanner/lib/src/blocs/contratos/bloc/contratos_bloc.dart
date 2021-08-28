import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'contratos_event.dart';
part 'contratos_state.dart';

class ContratosBloc extends Bloc<ContratosEvent, ContratosState> {
  ContratosBloc() : super(ContratosInitial());

  @override
  Stream<ContratosState> mapEventToState(
    ContratosEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
