import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/dashboard_logic/dashboard_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/eventosModel/eventos_dashboard_model.dart';
import 'package:planning/src/ui/planes/calendario.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardLogic logic = DashboardLogic();
  DashboardBloc({this.logic}) : super(DashboardInitial()) {
    on<MostrarFechasEvent>((event, emit) async {
      try {
        // final eventos = await logic.getAllFechasEventos();
        // final actividades = await logic.getAllActivitiesPlanner();
        // emit(MostrarEventosState(eventos, actividades));
      } catch (e) {
        ('Error en el bloc');
        (e);
      }
    });
  }
}
