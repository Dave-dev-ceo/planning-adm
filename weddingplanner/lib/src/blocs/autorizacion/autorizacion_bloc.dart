import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'autorizacion_event.dart';
part 'autorizacion_state.dart';

class AutorizacionBloc extends Bloc<AutorizacionEvent, AutorizacionState> {
  AutorizacionBloc() : super(AutorizacionInitial());

  @override
  Stream<AutorizacionState> mapEventToState(
    AutorizacionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
