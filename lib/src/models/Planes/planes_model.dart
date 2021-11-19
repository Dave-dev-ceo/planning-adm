class PlannesModel {
  PlannesModel({
    this.idPlanner,
    this.nombrePlanner,
    this.idPlannerOld,
    this.idActividad,
    this.nombreActividad,
    this.descripcionActividad,
    this.visibleForInvolucrados,
    this.diasDeLaActividad,
    this.estadoCalendario,
    this.estatusProgreso,
    this.estatus,
  });

  int idPlanner;
  String nombrePlanner;
  int idPlannerOld;
  int idActividad;
  String nombreActividad;
  String descripcionActividad;
  bool visibleForInvolucrados;
  int diasDeLaActividad;
  bool estadoCalendario;
  bool estatusProgreso;
  String estatus;

  factory PlannesModel.fromJson(Map<String, dynamic> json) => PlannesModel(
        idPlanner: json['id_planer'],
        nombrePlanner: json['nombre_planer'],
        idPlannerOld: json['id_planer_old'],
        idActividad: json['id_actividad'],
        nombreActividad: json['nombre_actividad'],
        descripcionActividad: json['descripcion_actividad'],
        visibleForInvolucrados: json['visible_involucrados_actividad'],
        diasDeLaActividad: json['dias_actividad'],
        estadoCalendario: json['estado_calendario_actividad'],
        estatusProgreso: json['estatus_progreso'],
        estatus: json['estatus'],
      );

  Map<String, dynamic> toJson() => {
        'id_planer': idPlanner,
        'nombre_planer': nombrePlanner,
        'id_planer_old': idPlannerOld,
        'id_actividad': idActividad,
        'nombre_actividad': nombreActividad,
        'descripcion_actividad': descripcionActividad,
        'visible_involucrados_actividad': visibleForInvolucrados,
        'dias_actividad': diasDeLaActividad,
        'estado_calendario_actividad': estadoCalendario,
        'estatus_progreso': estatusProgreso,
        'estatus': estatus,
      };
}
