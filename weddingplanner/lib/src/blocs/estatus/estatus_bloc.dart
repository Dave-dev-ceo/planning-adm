import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/estatus_logic.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';

part 'estatus_event.dart';
part 'estatus_state.dart';

class EstatusBloc extends Bloc<EstatusEvent, EstatusState> {
  final ListaEstatusLogic logic;
  EstatusBloc({@required this.logic}) : super(EstatusInitial());

  @override
  Stream<EstatusState> mapEventToState(
    EstatusEvent event,
  ) async* {
    if(event is FechtEstatusEvent){
      yield LoadingEstatusState();

      try {
        
        ItemModelEstatusInvitado estatus = await logic.fetchEstatus();
        yield MostrarEstatusState(estatus);

      }on ListaEstatusException{
        
        yield ErrorListaEstatusState("Sin estatus");
      
      }on TokenException{
        yield ErrorTokenEstatusState("Sesión caducada");
      }
    }else if(event is CreateEstatusEvent){
      try {
        int idEstatusInvitado = await logic.createEstatus(event.data);
        ItemModelEstatusInvitado model = event.estatus;
        String dato = event.data['descripcion'];
        Map<String,dynamic> lista = {'id_estatus_invitado':idEstatusInvitado,'descripcion':dato};
        Estatus est = new Estatus(lista);
        model.results.add(est);
        //yield CreateEstatusState(estatus);
        yield MostrarEstatusState(model);
      }on CreateEstatusException{
        yield ErrorCreateEstatusState("No se pudo insertar");
      }
    }else if(event is UpdateEstatusEvent){
      bool response = await logic.updateEstatus(event.data);
      ItemModelEstatusInvitado model = event.estatus;
      if(response){
        //model.results[event.id].addDescripcion = event.data['descripcion'];
        for(int i = 0; i < model.results.length; i++){
          if(model.results.elementAt(i).idEstatusInvitado == event.id){
            model.results.elementAt(i).addDescripcion = event.data['descripcion'];
          }
        }
      }
      yield MostrarEstatusState(model);
    }
  }
}
