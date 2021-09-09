import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'evento_pago_event.dart';
part 'evento_pago_state.dart';

class EventoPagoBloc extends Bloc<EventoPagoEvent, EventoPagoState> {
  EventoPagoBloc() : super(EventoPagoInitial());

  @override
  Stream<EventoPagoState> mapEventToState(
    EventoPagoEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
