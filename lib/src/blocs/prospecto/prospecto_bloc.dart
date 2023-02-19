import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/prospecto_logic/prospecto_logic.dart';
import 'package:planning/src/models/prospectosModel/prospecto_model.dart';

part 'prospecto_event.dart';
part 'prospecto_state.dart';

class ProspectoBloc extends Bloc<ProspectoEvent, ProspectoState> {
  final ProspectoLogic logic;
  ProspectoBloc({required this.logic}) : super(ProspectoInitial()) {
    on<MostrarEtapasEvent>((event, emit) async {
      try {
        final data = await logic.getEtapasAndProspectos();

        emit(MostrarEtapasState(data));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<AddProspectoEvent>((event, emit) async {
      try {
        await logic.addEtapasUpdate(event.newProspecto);

        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateEtapaProspectoEvent>((event, emit) async {
      try {
        await logic.updateEtapaProspecto(event.idEtapa, event.idProspecto);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateEtapaEvent>((event, emit) async {
      try {
        await logic.updateEtapa(event.listEtapasUpdate);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<AddEtapaEvent>((event, emit) async {
      try {
        final data = await logic.addEtapa(event.newEtapa);
        emit(AddedEtapaState(data));

        final etapas = await logic.getEtapasAndProspectos();

        emit(MostrarEtapasState(etapas));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateNameProspecto>((event, emit) async {
      try {
        await logic.updateNameProspecto(event.editProspecto);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
    on<UpdateTelefonoProspecto>((event, emit) async {
      try {
        await logic.updatePhoneProspecto(event.editProspecto);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateCorreoProspecto>((event, emit) async {
      try {
        await logic.updateCorreoProspecto(event.editProspecto);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateDescripcionProspecto>((event, emit) async {
      try {
        await logic.updateDescripcionProspecto(event.editProspecto);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<InsertActividadProspecto>((event, emit) async {
      try {
        await logic.insertActividadProspecto(event.newActividad);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<EditNameEtapaEvent>((event, emit) async {
      try {
        await logic.editNameEtapa(event.etapaToEdit);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<DeleteEtapaEvent>((event, emit) async {
      try {
        await logic.deleteEtapa(event.idEtapa);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<DeleteActividadEvent>((event, emit) async {
      try {
        await logic.deleteActividadProspecto(event.idActividad);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateActividadEvent>((event, emit) async {
      try {
        await logic.editActividad(event.actividadToEdit);

        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<UpdateDatosEtapa>((event, emit) async {
      try {
        final data = await logic.editDatosEtapas(event.estapaToEdit);
        emit(AddedEtapaState(data));
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<EditInvolucradoEvent>((event, emit) async {
      try {
        await logic.editInvolucrado(event.prospectoModel);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<EventoFromProspectoEvent>((event, emit) async {
      try {
        await logic.eventoFromProspecto(event.idProspecto);
        add(MostrarEtapasEvent());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    on<DeleteProspectoEvent>((event, emit) async {
      try {
        final data = await logic.deleteProspecto(event.idProspecto);

        if (data) {
          emit(DeleteProspectoSuccessState());
          add(MostrarEtapasEvent());
        } else {
          emit(DeleteProspectoErrorState());
          add(MostrarEtapasEvent());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  @override
  void onTransition(Transition<ProspectoEvent, ProspectoState> transition) {
    super.onTransition(transition);
  }
}
