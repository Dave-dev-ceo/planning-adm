import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/invitados_mesas_logic/invitados_mesa_logic.dart';
import 'package:weddingplanner/src/models/invitadosConfirmadosModel/invitado_mesa_Model.dart';

part 'invitadosmesas_event.dart';
part 'invitadosmesas_state.dart';

class InvitadosMesasBloc
    extends Bloc<InvitadosMesasEvent, InvitadosMesasState> {
  final InvitadosConfirmadosLogic logic;

  InvitadosMesasBloc({@required this.logic}) : super(InvitadosmesasInitial());

  @override
  Stream<InvitadosMesasState> mapEventToState(
      InvitadosMesasEvent event) async* {
    if (event is MostrarInvitadosMesasEvent) {
      yield LoadingInvitadoMesasState();
      try {
        List<InvitadosConfirmadosModel> listaInvitados =
            await logic.getInvitadosConfirmados();
        yield MostraListaInvitadosMesaState(listaInvitados);
      } on InvitadosMesasException {
        yield ErrorInvitadoMesaState('Ocurrio un error');
      }
    }
  }
}