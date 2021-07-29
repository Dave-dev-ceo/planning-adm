import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/lista/detalle_lista/detalle_listas_event.dart';
import 'package:weddingplanner/src/blocs/lista/detalle_lista/detalle_listas_state.dart';
import 'package:weddingplanner/src/logic/detalle_listas_logic.dart';

class DetalleListasBloc extends Bloc<DetalleListasEvent, DetalleListasState> {
  final DetallesListasLogic logic;
  DetalleListasBloc({@required this.logic}) : super(DetalleListasInitial());

  @override
  Stream<DetalleListasState> mapEventToState(DetalleListasEvent event) async* {}
}
