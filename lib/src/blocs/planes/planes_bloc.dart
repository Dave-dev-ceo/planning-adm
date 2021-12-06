import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_evento_timing.dart';
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
        add(GetTimingsAndActivitiesEvent());
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
        yield GetAllPlanesState(listPlannes);
      } on ListaPlanesException {
        yield ErrorMostrarPlanesState('Sin Planes');
      }
    } else if (event is GetTimingsAndActivitiesEvent) {
      yield LodingPlanesState();

      try {
        final data = await logic.getTimingsAndActivities();

        yield ShowAllPlannesState(data);
      } catch (e) {
        print(e);
      }
    } else if (event is BorrarActividadPlanEvent) {
      try {
        final data = await logic.deleteActividadEvento(event.idActividad);
        add(GetTimingsAndActivitiesEvent());
      } catch (e) {}
    } else if (event is UpdateActividadesEventoEvent) {
      try {
        final data = await logic.updateEventoActividades(event.actividades);

        add(GetTimingsAndActivitiesEvent());
      } catch (e) {}
    } else if (event is AddNewActividadEvent) {
      try {
        final data = await logic.addNewActividadEvento(
            event.actividad, event.idEventoTiming);
        yield AddedActividadState(data);
        add(GetTimingsAndActivitiesEvent());
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void onTransition(Transition<PlanesEvent, PlanesState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
