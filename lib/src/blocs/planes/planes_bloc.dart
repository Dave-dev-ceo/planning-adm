import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_planes.dart';

part 'planes_event.dart';
part 'planes_state.dart';

class PlanesBloc extends Bloc<PlanesEvent, PlanesState> {
  final PlanesLogic logic;
  PlanesBloc({@required this.logic}) : super(InitiaPlaneslState());

  @override
  Stream<PlanesState> mapEventToState(
    PlanesEvent event,
  ) async* {
    if (event is SelectPlanesEvent) {
      yield LodingPlanesState();
      try {
        ItemModelPlanes planes = await logic.selectPlanesPlanner();
        yield SelectPlanesState(planes);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('Sin Planes');
      } on TokenException {
        yield ErrorTokenPlanesState('Sin Token');
      }
    } else if (event is CreatePlanesEvent) {
      try {
        bool data = await logic.crearTareasEventoLista(event.planesPlanner);
        yield CreatePlanesState(data);
      } on CrearPlannerPlanesException {
        yield ErrorMostrarPlanesState('Error al crear');
      } on TokenException {
        yield ErrorTokenPlanesState('Sin Token');
      }
    } else if (event is SelectPlanesEventoEvent) {
      yield LodingPlanesState();
      try {
        ItemModelPlanes full = await logic.selectPlanesEvento('');
        ItemModelPlanes planes = await logic.selectPlanesEvento(event.myQuery);
        yield SelectEventoState(planes, full);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('Sin Planes');
      } on TokenException {
        yield ErrorTokenPlanesState('Sin Token');
      }
    } else if (event is UpdatePlanesEventoEvent) {
      yield LodingPlanesState();
      try {
        // funcional pero no es correcto
        await logic.updateActividadEvento(event.actividades);
        ItemModelPlanes full = await logic.selectPlanesEvento('');
        ItemModelPlanes planes =
            await logic.selectPlanesEvento(event.querySelect);
        yield SelectEventoState(planes, full);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('No Update');
      } on TokenException {
        yield ErrorTokenPlanesState('Sin Token');
      }
    } else if (event is CreateUnaPlanesEvent) {
      yield LodingPlanesState();
      try {
        // funcional pero no es correcto
        await logic.createActividadEvento(event.actividad, event.idTarea);
        ItemModelPlanes full = await logic.selectPlanesEvento('');
        ItemModelPlanes planes =
            await logic.selectPlanesEvento(event.querySelect);
        yield SelectEventoState(planes, full);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('No Add');
      } on TokenException {
        yield ErrorTokenPlanesState('Sin Token');
      }
    } else if (event is DeleteAnActividadEvent) {
      yield LodingPlanesState();
      try {
        // funcional pero no es correcto
        await logic.deleteActividadEvento(event.idActividad);
        ItemModelPlanes full = await logic.selectPlanesEvento('');
        ItemModelPlanes planes =
            await logic.selectPlanesEvento(event.querySelect);
        yield SelectEventoState(planes, full);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('No Add');
      } on TokenException {
        yield ErrorTokenPlanesState('Sin Token');
      }
    } else if (event is GetAllPlannesEvent) {
      yield LoadingAllPlanesState();

      try {
        final listPlannes = await logic.getAllPlannes();

        print('Estatus de la lista desde el bloc');
        print(listPlannes);
        yield GetAllPlanesState(listPlannes);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('Sin Planes');
      }
    }
  }
}
