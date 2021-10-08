import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/models/mesas_model.dart';

part 'mesas_event.dart';
part 'mesas_state.dart';

class MesasAsignadasBloc extends Bloc<MesasEvent, MesasState> {
  MesasAsignadasBloc() : super(MesasInitial()) {
    on<MesasEvent>((event, emit) async* {
      if (event is MostrarMesasAsignadasEvent) {
        yield LoadingMesasAsignadasState();

        try {
          yield MostrarMesasAsignadasState();
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
