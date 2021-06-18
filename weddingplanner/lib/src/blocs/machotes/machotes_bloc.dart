import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/machotes_logic.dart';
import 'package:weddingplanner/src/models/item_model_machotes.dart';

part 'machotes_event.dart';
part 'machotes_state.dart';

class MachotesBloc extends Bloc<MachotesEvent, MachotesState> {
  final ListaMachotesLogic logic;
  MachotesBloc({@required this.logic}) : super(MachotesInitial());

  @override
  Stream<MachotesState> mapEventToState(
    MachotesEvent event,
  ) async* {
    if(event is FechtMachotesEvent){
      yield LoadingMachotesState();

      try {
        
        ItemModelMachotes machotes = await logic.fetchMachotes();
        yield MostrarMachotesState(machotes);

      }on ListaMachotesException{
        
        yield ErrorListaMachotesState("Sin machotes");
      
      }on TokenException{
        yield ErrorTokenMachotesState("Sesión caducada");
      }
    }else if(event is CreateMachotesEvent){
      try {
        int idMachotes = await logic.createMachotes(event.data);
        /*ItemModelMachotes model = event.machotes;
        String dato = event.data['descripcion'];
        String tipo = event.data['machote'];
        Map<String,dynamic> lista = {'id_machote':idMachotes,'descripcion':dato, 'machote':tipo};
        Machotes est = new Machotes(lista);
        model.results.add(est);*/
        //yield CreateMachotesState(machotes);
        //yield MostrarMachotesState(model);
        add(FechtMachotesEvent());
        
      }on CreateMachotesException{
        yield ErrorCreateMachotesState("No se pudo insertar");
      }
    }else if(event is UpdateMachotesEvent){
      try{
        bool response = await logic.updateMachotes(event.data);

        if(response){
          add(FechtMachotesEvent());  
        }
      }on UpdateMachotesException{
        yield ErrorUpdateMachotesState("No de actualizo");
      }
    }
  }
}
