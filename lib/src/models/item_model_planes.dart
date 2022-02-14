class ItemModelPlanes {
  // nuestrs lista
  List<_Planes> _planes = [];

  // constructor
  ItemModelPlanes(this._planes);

  // metodo crea item
  ItemModelPlanes.fromJson(List<dynamic> pardedJson) {
    List<_Planes> temp = []; // variable temp para ir agregando

    // extrameos los datos - metodo forEach
    for (var data in pardedJson) {
      temp.add(_Planes(data));
    }

    _planes = temp;
  }

  // no ocupo metodo copy/copyWith

  // data que recuperamos
  List<_Planes> get planes => _planes;
}

// mi objeto
class _Planes {
  // mis variables
  // parte de tares
  int _idPlan;
  String _nombrePlan;
  DateTime _fechaInicioEvento;
  DateTime _fechaFinalEvento;
  int _idOldPlan;
  // parte de actividades
  int _idActividad;
  String _nombreActividad;
  String _nombreResponsable;
  String _descripcionActividad;
  bool _visibleInvolucradosActividad;
  int _duracionActividad;
  int _predecesorActividad;
  bool _statusCalendar;
  DateTime _fechaInicioActividad;
  int _idOldActividad;
  bool _statusProgreso;
  int _tiempoAntes;

  // constructor
  _Planes(result) {
    // parte de tares
    _idPlan = result['id_planer'];
    _nombrePlan = result['nombre_planer'];
    _fechaInicioEvento = DateTime.parse(result['fecha_inicio_evento']);
    _fechaFinalEvento = DateTime.parse(result['fecha_final_evento']);
    _idOldPlan = result['id_planer_old'];
    // parte de actividades
    _idActividad = result['id_actividad'];
    _nombreActividad = result['nombre_actividad'];
    _nombreResponsable = result['responsable'];
    _descripcionActividad = result['descripcion_actividad'];
    _visibleInvolucradosActividad = result['visible_involucrados_actividad'];
    _duracionActividad = result['dias_actividad'];
    _predecesorActividad = result['predecesor_actividad'];
    _statusCalendar = result['estado_calendario_actividad'];
    _fechaInicioActividad = DateTime.parse(result['fecha_inicio_actividad']);
    _idOldActividad = result['id_actividad_old'];
    _statusProgreso = result['estatus_progreso'];
    _tiempoAntes = result['tiempo_antes'];
  }

  // creamos getters
  // parte de tares
  int get idPlan => _idPlan;
  String get nombrePlan => _nombrePlan;
  DateTime get fechaInicioEvento => _fechaInicioEvento;
  DateTime get fechaFinalEvento => _fechaFinalEvento;
  int get idOldPlan => _idOldPlan;
  // parte de actividades
  int get idActividad => _idActividad;
  String get nombreActividad => _nombreActividad;
  String get nombreResponsable => _nombreResponsable;
  String get descripcionActividad => _descripcionActividad;
  bool get visibleInvolucradosActividad => _visibleInvolucradosActividad;
  int get duracionActividad => _duracionActividad;
  int get predecesorActividad => _predecesorActividad;
  bool get statusCalendar => _statusCalendar;
  DateTime get fechaInicioActividad => _fechaInicioActividad;
  int get idOldActividad => _idOldActividad;
  bool get statusProgreso => _statusProgreso;
  int get tiempoAntes => _tiempoAntes;

  // creamos setters
  // parte de tares
  set idPlan(value) => _idPlan;
  set nombrePlan(value) => _nombrePlan;
  set fechaInicioEvento(value) => _fechaInicioEvento;
  set fechaFinalEvento(value) => _fechaFinalEvento;
  set idOldPlan(value) => _idOldPlan;
  // parte de actividades
  set idActividad(value) => _idActividad;
  set nombreActividad(value) => _nombreActividad;
  set descripcionActividad(value) => _descripcionActividad;
  set visibleInvolucradosActividad(value) => _visibleInvolucradosActividad;
  set duracionActividad(value) => _duracionActividad;
  set predecesorActividad(value) => _predecesorActividad;
  set statusCalendar(value) => _statusCalendar;
  set fechaInicioActividad(value) => _fechaInicioActividad;
  set idOldActividad(value) => _idOldActividad;
  set statusProgreso(value) => _statusProgreso;
  set tiempoAntes(int value) => _tiempoAntes;
}
