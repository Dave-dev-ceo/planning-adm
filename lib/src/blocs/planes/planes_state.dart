part of 'planes_bloc.dart';

@immutable
abstract class PlanesState {}

// estado - inicial
class InitiaPlaneslState extends PlanesState {}

// estado - cargando
class LodingPlanesState extends PlanesState {}

// estado - select
class SelectPlanesState extends PlanesState {
  final ItemModelPlanes planes;

  SelectPlanesState(this.planes);

  ItemModelPlanes get props => planes;
}

// estado - crear
class CreatePlanesState extends PlanesState {
  final bool status;

  CreatePlanesState(this.status);

  bool get props => status;
}

// estado - select
class SelectEventoState extends PlanesState {
  final ItemModelPlanes planes;
  final ItemModelPlanes full;

  SelectEventoState(this.planes, this.full);

  ItemModelPlanes get props => planes;
  ItemModelPlanes get prop => full;
}

class GetAllPlanesState extends PlanesState {
  final List<PlannesModel> plannes;

  GetAllPlanesState(this.plannes);
}

class LoadingAllPlanesState extends PlanesState {}

// estado - errores
class ErrorMostrarPlanesState extends PlanesState {
  final String message;

  ErrorMostrarPlanesState(this.message);

  List<Object> get props => [message];
}

class ErrorTokenPlanesState extends PlanesState {
  final String message;

  ErrorTokenPlanesState(this.message);

  List<Object> get props => [message];
}

class ShowAllPlannesState extends PlanesState {
  final List<TimingModel> listTimings;

  ShowAllPlannesState(this.listTimings);

  @override
  List<Object> get props => [listTimings];
}

class AddedActividadState extends PlanesState {
  final bool isAdded;

  AddedActividadState(this.isAdded);

  Object get props => isAdded;
}
