part of 'plantiilas_sistema_bloc.dart';

@immutable
abstract class PlantillasSistemaEvent {}

class ObtenerPlantillasEvent extends PlantillasSistemaEvent {}

class InsertPlantillasEvent extends PlantillasSistemaEvent {
  final PlantillaSistemaModel newPlantilla;

  InsertPlantillasEvent(this.newPlantilla);
}

class EditDescripcionPlantillaEvent extends PlantillasSistemaEvent {
  final PlantillaSistemaModel editPlantilla;

  EditDescripcionPlantillaEvent(this.editPlantilla);
}

class DeletePlantillaSistemaEvent extends PlantillasSistemaEvent {
  final int idPlantilla;

  DeletePlantillaSistemaEvent(this.idPlantilla);
}
