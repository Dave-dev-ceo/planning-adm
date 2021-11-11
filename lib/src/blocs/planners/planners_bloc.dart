import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/planners_logic.dart';
import 'package:weddingplanner/src/models/item_model_planners.dart';

part 'planners_event.dart';
part 'planners_state.dart';

class PlannersBloc extends Bloc<PlannersEvent, PlannersState> {
  final ListaPlannersLogic logic;
  PlannersBloc({@required this.logic}) : super(PlannersInitialState());

  @override
  Stream<PlannersState> mapEventToState(
    PlannersEvent event,
  ) async* {
     if(event is FechtPlannersEvent){
      yield LoadingPlannersState();

      try {
        
        ItemModelPlanners planners = await logic.fetchPrueba();
        yield MostrarPlannersState(planners);

      }on ListaPlannersException{
        
        yield ErrorListaPlannersState("Sin planners");
      
      }
    }else if(event is CreatePlannersEvent){
      try {
        int idPlanner = await logic.createPlanners(event.data);
        ItemModelPlanners model = event.planners;
        //String dato = event.data['descripcion'];
        Map<String,dynamic> lista = {
          'id_planner':idPlanner,
          'empresa':event.data['empresa'],
          'correo':event.data['correo'],
          'telefono':event.data['telefono'],
          'pais':event.data['pais']};
          ResultsPlanners res = new ResultsPlanners(lista);
        /*Estatus est = new Estatus(lista);*/
        model.results.add(res);
        //yield CreateEstatusState(estatus);
        yield MostrarPlannersState(model);
      }on CreatePlannersException{
        yield ErrorCreatePlannersState("No se pudo insertar");
      }
    }
  }
}
