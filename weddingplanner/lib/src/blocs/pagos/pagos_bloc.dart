import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pagos_event.dart';
part 'pagos_state.dart';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  PagosBloc() : super(PagosInitial());

  @override
  Stream<PagosState> mapEventToState(
    PagosEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
