import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'evento_timing_event.dart';
part 'evento_timing_state.dart';

class EventoTimingBloc extends Bloc<EventoTimingEvent, EventoTimingState> {
  EventoTimingBloc() : super(EventoTimingInitial());

  @override
  Stream<EventoTimingState> mapEventToState(
    EventoTimingEvent event,
  ) async* {}
}
