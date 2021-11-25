import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/mesas_asignadas_logic/mesas_asignadas_services.dart';
import 'package:planning/src/models/MesasAsignadas/mesas_asignadas_model.dart';

part 'mesasasignadas_event.dart';
part 'mesasasignadas_state.dart';

class MesasAsignadasBloc
    extends Bloc<MesasAsignadasEvent, MesasAsignadasState> {
  MesasAsignadasService service = MesasAsignadasService();
  MesasAsignadasBloc() : super(MesasasignadasInitial());

  @override
  Stream<MesasAsignadasState> mapEventToState(
      MesasAsignadasEvent event) async* {
    if (event is GetMesasAsignadasEvent) {
      yield LoadingMesasAsignadasState();

      try {
        final mesasAsignadas = await service.getMesasAsignadas();
        yield MostrarMesasAsignadasState(mesasAsignadas);
      } catch (e) {}
    } else if (event is DeleteAsignadoFromMesaEvent) {
      try {
        final resp =
            await service.deleteAsignadoFromMesa(event.asignadosToDelete);

        yield DeletedAsignadoFromMesaState(resp);

        add(GetMesasAsignadasEvent());
      } catch (e) {
        print(e);
      }
    } else if (event is AsignarPersonasMesasEvent) {
      try {
        final resp =
            await service.asignarPersonasMesas(event.listAsignarMesaModel);
        yield AddedAsignadoFromMesaState(resp);
        add(GetMesasAsignadasEvent());
      } catch (e) {
        print(e);
      }
    }
  }
}
