import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/platillasSistema/plantillas_logic.dart';
import 'package:planning/src/models/PlantillaSistema/plantiila_sistema_model.dart';

part 'plantiilas_sistema_event.dart';
part 'plantiilas_sistema_state.dart';

class PlantillasSistemaBloc
    extends Bloc<PlantillasSistemaEvent, PlantillasSistemaState> {
  PlantillasSistemaBloc() : super(PlantiilasSistemaInitial()) {
    final logic = PlantillasLogic();
    on<ObtenerPlantillasEvent>((event, emit) async {
      try {
        final data = await logic.obtenerPlantillas();

        if (data != null) {
          emit(MostrarPlantillasSistemaState(data));
        } else {
          emit(ErrorObtenerListState());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorObtenerListState());
      }
    });

    on<InsertPlantillasEvent>((event, emit) async {
      try {
        final data = await logic.insertPlantilla(event.newPlantilla);

        if (data) {
          emit(SuccessInsertPlantillaState());
        } else {
          emit(ErrorInsertPlantillaState());
        }
        add(ObtenerPlantillasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorInsertPlantillaState());
        add(ObtenerPlantillasEvent());
      }
    });

    on<EditDescripcionPlantillaEvent>((event, emit) async {
      try {
        final data = await logic.editDescripcionPlantilla(event.editPlantilla);
        if (data) {
          emit(SuccessEditDesPlantillaState());
        } else {
          emit(ErrorEditDesPlantillaState());
        }
        add(ObtenerPlantillasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorEditDesPlantillaState());
        add(ObtenerPlantillasEvent());
      }
    });

    on<DeletePlantillaSistemaEvent>((event, emit) async {
      try {
        final data = await logic.deletePlantillaSistema(event.idPlantilla);

        if (data) {
          emit(SuccessDeletePlantillaState());
        } else {
          emit(ErrorDeletePlantillaState());
        }
        add(ObtenerPlantillasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorDeletePlantillaState());
        add(ObtenerPlantillasEvent());
      }
    });
  }
}
