import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/contratos_logic.dart';
import 'package:planning/src/models/item_model_contratos.dart';

part 'contratos_event.dart';
part 'contratos_state.dart';

class ContratosBloc extends Bloc<ContratosEvent, ContratosState> {
  final ListaContratosLogic logic;
  ContratosBloc({@required this.logic}) : super(ContratosInitial());

  @override
  Stream<ContratosState> mapEventToState(
    ContratosEvent event,
  ) async* {
    if (event is FechtContratosEvent) {
      yield LoadingContratosState();

      try {
        ItemModelContratos contratos = await logic.fetchContratos();
        yield MostrarContratosState(contratos);
      } on ListaContratosException {
        yield ErrorListaContratosState("Sin contratos");
      } on TokenException {
        yield ErrorTokenContratosState("Sesión caducada");
      }
    } else if (event is CreateContratosEvent) {
      try {
        int idContratos = await logic.createContratos(event.data);
        ItemModelContratos model = event.contratos;
        String dato = event.data['descripcion'];
        String tipo = event.data['contrato'];
        Map<String, dynamic> lista = {
          'id_contrato': idContratos,
          'descripcion': dato,
          'contrato': tipo
        };
        Contratos est = new Contratos(lista);
        model.results.add(est);
        //yield CreateContratosState(contratos);
        yield MostrarContratosState(model);
      } on CreateContratosException {
        yield ErrorCreateContratosState("No se pudo insertar");
      }
    } else if (event is UpdateContratosEvent) {
      bool response = await logic.updateContratos(event.data);
      ItemModelContratos model = event.contratos;
      if (response) {
        //model.results[event.id].addDescripcion = event.data['descripcion'];
        for (int i = 0; i < model.results.length; i++) {
          if (model.results.elementAt(i).idContrato == event.id) {
            model.results.elementAt(i).addDescripcion =
                event.data['descripcion'];
          }
        }
      }
      yield MostrarContratosState(model);
    } else if (event is FechtContratosPdfEvent) {
      yield LoadingContratosPdfState();
      try {
        String contrato = await logic.fetchContratosPdf(event.data);
        yield MostrarContratosPdfState(contrato);
      } on ListaContratosPdfException {
        yield ErrorListaContratosPdfState("Error contrato");
      } on TokenException {
        yield ErrorTokenContratosState("Sesión caducada");
      }
    } else if (event is FechtContratosPdfViewEvent) {
      yield LoadingContratosPdfViewState();
      try {
        String contrato = await logic.fetchContratosPdf(event.data);
        yield MostrarContratosPdfViewState(contrato);
      } on ListaContratosPdfException {
        yield ErrorListaContratosPdfState("Error contrato");
      } on TokenException {
        yield ErrorTokenContratosState("Sesión caducada");
      }
    } else if (event is UploadFileEvent) {
      yield LoadingUploadFileState();
      try {
        Map<String, dynamic> data = {
          'id_machote': event.id,
          'archivo': event.file,
          'descripcion': event.name
        };

        bool contrato = await logic.updateFile(data);
        // yield MostrarContratosPdfViewState(contrato);
      } on ListaContratosPdfException {
        yield ErrorListaContratosPdfState("Error contrato");
      } on TokenException {
        yield ErrorTokenContratosState("Sesión caducada");
      }
    } else if (event is SeeUploadFileEvent) {
      yield LoadingSeeUploadFileState();
      try {
        Map<String, dynamic> data = {'id_machote': event.id.toString()};

        String contrato = await logic.seeUploadFile(data);
        yield MostrarUploadPdfViewState(contrato);
      } on ListaContratosPdfException {
        yield ErrorListaContratosPdfState("Error contrato");
      } on TokenException {
        yield ErrorTokenContratosState("Sesión caducada");
      }
    }
  }
}
