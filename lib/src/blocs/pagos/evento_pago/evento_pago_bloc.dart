import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'evento_pago_event.dart';
part 'evento_pago_state.dart';

class EventoPagoBloc extends Bloc<EventoPagoEvent, EventoPagoState> {
  EventoPagoBloc() : super(EventoPagoInitial());

  @override
  Stream<EventoPagoState> mapEventToState(
    EventoPagoEvent event,
  ) async* {}
}
