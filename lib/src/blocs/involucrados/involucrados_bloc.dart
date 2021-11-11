import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/involucrados_logic.dart';
import 'package:weddingplanner/src/models/item_model_involucrados.dart';

part 'involucrados_event.dart';
part 'involucrados_state.dart';

class InvolucradosBloc extends Bloc<InvolucradosEvent, InvolucradosState> {
  final Involucrados logic;
  InvolucradosBloc({@required this.logic}) : super(InvolucradosInitial());

  @override
  Stream<InvolucradosState> mapEventToState(
    InvolucradosEvent event,
  ) async* {
    if(event is SelectInvolucrado) {
      yield InvolucradosLogging();

      try {
        ItemModelInvolucrados involucrados = await logic.selectInvolucrado();
        yield InvolucradosSelect(involucrados);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }

    } else if(event is InsertInvolucrado) {
      yield InvolucradosLogging();

      try {
        await logic.insertInvolucrados(event.involucrado);
        ItemModelInvolucrados involucrados = await logic.selectInvolucrado();
        yield InvolucradosInsert(involucrados);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en consulta');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }

    }
  }
}
