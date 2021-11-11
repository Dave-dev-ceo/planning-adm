class ItemModelPlanes {
  // nuestrs lista
  List<_Planes> _planes = [];

  // constructor
  ItemModelPlanes(this._planes);

  // metodo crea item
  ItemModelPlanes.fromJson(List<dynamic> pardedJson) {
    List<_Planes> temp = []; // variable temp para ir agregando

    // extrameos los datos - metodo forEach
    pardedJson.forEach((data) {
      temp.add(_Planes(data));
    });

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
  String _descripcionActividad;
  bool _visibleInvolucradosActividad;
  int _duracionActividad;
  int _predecesorActividad;
  bool _statusCalendar;
  DateTime _fechaInicioActividad;
  int _idOldActividad;
  bool _statusProgreso;

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
    _descripcionActividad = result['descripcion_actividad'];
    _visibleInvolucradosActividad = result['visible_involucrados_actividad'];
    _duracionActividad = result['dias_actividad'];
    _predecesorActividad = result['predecesor_actividad'];
    _statusCalendar = result['estado_calendario_actividad'];
    _fechaInicioActividad = DateTime.parse(result['fecha_inicio_actividad']);
    _idOldActividad = result['id_actividad_old'];
    _statusProgreso = result['estatus_progreso'];
  }

  // creamos getters
  // parte de tares
  int get idPlan => this._idPlan;
  String get nombrePlan => this._nombrePlan;
  DateTime get fechaInicioEvento => this._fechaInicioEvento;
  DateTime get fechaFinalEvento => this._fechaFinalEvento;
  int get idOldPlan => this._idOldPlan;
  // parte de actividades
  int get idActividad => this._idActividad;
  String get nombreActividad => this._nombreActividad;
  String get descripcionActividad => this._descripcionActividad;
  bool get visibleInvolucradosActividad => this._visibleInvolucradosActividad;
  int get duracionActividad => this._duracionActividad;
  int get predecesorActividad => this._predecesorActividad;
  bool get statusCalendar => this._statusCalendar;
  DateTime get fechaInicioActividad => this._fechaInicioActividad;
  int get idOldActividad => this._idOldActividad;
  bool get statusProgreso => this._statusProgreso;

  // creamos setters
  // parte de tares
  set idPlan(value) => this._idPlan;
  set nombrePlan(value) => this._nombrePlan;
  set fechaInicioEvento(value) => this._fechaInicioEvento;
  set fechaFinalEvento(value) => this._fechaFinalEvento;
  set idOldPlan(value) => this._idOldPlan;
  // parte de actividades
  set idActividad(value) => this._idActividad;
  set nombreActividad(value) => this._nombreActividad;
  set descripcionActividad(value) => this._descripcionActividad;
  set visibleInvolucradosActividad(value) => this._visibleInvolucradosActividad;
  set duracionActividad(value) => this._duracionActividad;
  set predecesorActividad(value) => this._predecesorActividad;
  set statusCalendar(value) => this._statusCalendar;
  set fechaInicioActividad(value) => this._fechaInicioActividad;
  set idOldActividad(value) => this._idOldActividad;
  set statusProgreso(value) => this._statusProgreso;
}
