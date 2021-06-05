import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/paises_logic.dart';
import 'package:weddingplanner/src/models/item_model_paises.dart';

part 'paises_event.dart';
part 'paises_state.dart';

class PaisesBloc extends Bloc<PaisesEvent, PaisesState> {
  final ListaPaisesLogic logic;
  PaisesBloc({@required this.logic}) : super(PaisesInitialState());

  @override
  Stream<PaisesState> mapEventToState(
    PaisesEvent event,
  ) async* {
    if(event is FechtPaisesEvent){
      yield LoadingPaisesState();

      try {
        
        ItemModelPaises paises = await logic.fetchPrueba();
        yield MostrarPaisesState(paises);

      }on ListaPaisesException{
        
        yield ErrorListaPaisesState("Sin paises");
      
      }
    }
  }
}