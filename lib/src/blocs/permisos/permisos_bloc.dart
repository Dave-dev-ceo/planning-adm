import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/permisos_logic.dart';
import 'package:planning/src/models/model_perfilado.dart';

part 'permisos_event.dart';
part 'permisos_state.dart';

class PermisosBloc extends Bloc<PermisosEvent, PermisosState> {
  final PerfiladoLogic logic;
  PermisosBloc({@required this.logic}) : super(PermisosInitial()) {
    on<ObtenerPermisosEvent>((event, emit) async {
      emit(LoadingPermisos());

      try {
        ItemModelPerfil permisos = await logic.obtenerPermisosUsuario();
        emit(PermisosOk(permisos));
      } on PermisosException {
        emit(ErrorPermisos("Sin permisos"));
      } on TokenPermisosException {
        emit(ErrorTokenPermisos("Sesión caducada"));
      } on PaypalSubscriptionException {
        emit(ErrorSuscripcionPaypal(
            "No cuentas con una suscripción activa en Paypal."));
      }
    });

    on<PermisosSinConexion>((event, emit) {
      ItemModelPerfil _seccionesFiltradas = event.permisos;

      for (var seccion in _seccionesFiltradas.secciones.secciones) {
        for (var s in _seccionesFiltradas.secciones.secciones) {
          if (!(s.claveSeccion == 'WP-EVT')) {
            s.acceso = false;
          }
        }
      }

      emit(PermisosOk(_seccionesFiltradas));
    });
  }

  // @override
  // Stream<PermisosState> mapEventToState(
  //   PermisosEvent event,
  // ) async* {
  //   if (event is ObtenerPermisosEvent) {
  //     yield LoadingPermisos();

  //     try {
  //       ItemModelPerfil permisos = await logic.obtenerPermisosUsuario();
  //       yield PermisosOk(permisos);
  //     } on PermisosException {
  //       yield ErrorPermisos("Sin permisos");
  //     } on TokenPermisosException {
  //       yield ErrorTokenPermisos("Sesión caducada");
  //     } on PaypalSubscriptionException {
  //       yield ErrorSuscripcionPaypal(
  //           "No cuentas con una suscripción activa en Paypal.");
  //     }
  //   }
  // }

  @override
  void onTransition(Transition<PermisosEvent, PermisosState> transition) {
    super.onTransition(transition);
  }
}
