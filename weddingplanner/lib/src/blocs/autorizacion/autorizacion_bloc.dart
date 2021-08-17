import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:weddingplanner/src/logic/autorizacion_logic.dart';
import 'package:weddingplanner/src/models/item_model_autorizacion.dart';

part 'autorizacion_event.dart';
part 'autorizacion_state.dart';

class AutorizacionBloc extends Bloc<AutorizacionEvent, AutorizacionState> {
  final AutorizacionLogic logic;
  AutorizacionBloc({@required this.logic}) : super(AutorizacionInitial());

  @override
  Stream<AutorizacionState> mapEventToState(
    AutorizacionEvent event,
  ) async* {
    if(event is SelectAutorizacionEvent) {
      yield AutorizacionLodingState();
      try {
        ItemModelAutorizacion autorizacion = await logic.selectAutorizacion();
        yield AutorizacionSelectState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if(event is CrearAutorizacionEvent) {
      yield AutorizacionLodingState();
      try {
        await logic.createAutorizacion(event.data);
        ItemModelAutorizacion autorizacion = await logic.selectAutorizacion();
        yield AutorizacionCreateState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if(event is SelectEvidenciaEvent) {
      yield AutorizacionLodingState();
      try {
        ItemModelAutorizacion autorizacion = await logic.selectEvidencia(event.id);
        yield SelectEvidenciaState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select id');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if(event is UpdateAutorizacionEvent) {
      yield AutorizacionLodingState();
      try {
        await logic.updateAutorizacion(event.id, event.descripcion, event.comentario);
        ItemModelAutorizacion autorizacion = await logic.selectAutorizacion();
        yield AutorizacionSelectState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select id');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if(event is DeleteAutorizacionEvent) {
      yield AutorizacionLodingState();
      try {
        await logic.deleteAutorizacion(event.id);
        ItemModelAutorizacion autorizacion = await logic.selectAutorizacion();
        yield AutorizacionSelectState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en select id');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if(event is DeleteEvidenciaEvent) {
      yield AutorizacionLodingState();
      try {
        await logic.deleteImage(event.id);
        ItemModelAutorizacion autorizacion = await logic.selectEvidencia(event.autorizacion);
        yield SelectEvidenciaState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en imagen id');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } else if(event is CrearImagenEvent) {
      yield AutorizacionLodingState();
      try {
        await logic.addImage(event.data);
        ItemModelAutorizacion autorizacion = await logic.selectEvidencia(event.data['id_autorizacion']);
        yield SelectEvidenciaState(autorizacion);
      } on AutorizacionException {
        yield AutorizacionErrorState('Error en imagen id');
      } on TokenException {
        yield AutorizacionTokenErrorState('Error token');
      }
    } 
  }
}
