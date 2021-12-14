import 'package:planning/src/models/item_model_tipo_evento.dart';

class PlannesModel {
  bool estadoCalendario;
  bool estatusProgreso;
  bool visibleForInvolucrados;
  int diasDeLaActividad;
  int idActividad;
  int idPlanner;
  int idPlannerOld;
  String descripcionActividad;
  String estatus;
  String nombreActividad;
  String nombrePlanner;

  DateTime fechaInicioEvento;
  DateTime fechaFinalEvento;
  DateTime fechaInicioActividad;
  int idActividadOld;
  String responsable;

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
    this.fechaInicioEvento,
    this.fechaFinalEvento,
    this.fechaInicioActividad,
    this.idActividadOld,
    this.responsable,
  });

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
      fechaInicioEvento:
          DateTime.tryParse(json['fecha_inicio_evento']).toLocal(),
      fechaFinalEvento: DateTime.tryParse(json['fecha_final_evento']).toLocal(),
      fechaInicioActividad:
          DateTime.tryParse(json['fecha_inicio_actividad']).toLocal(),
      idActividadOld: json['id_actividad_old'],
      responsable: json['responsable']);

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
        'fecha_inicio_evento': fechaInicioEvento.toString(),
        'fecha_final_evento': fechaFinalEvento.toString(),
        'fecha_inicio_actividad': fechaInicioActividad.toString(),
        'id_actividad_old': idActividadOld,
        'responsable': responsable
      };
}

class TimingModel {
  int idPlanner;
  String nombrePlaner;
  int idPlanerOld;
  bool isAdd;
  List<EventoActividadModel> actividades;

  TimingModel({
    this.idPlanner,
    this.nombrePlaner,
    this.idPlanerOld,
    this.actividades,
    this.isAdd = false,
  });

  factory TimingModel.fromJson(Map<String, dynamic> json) => TimingModel(
        idPlanner: json['id_planer'],
        nombrePlaner: json['nombre_planer'],
        idPlanerOld: json['id_planer_old'],
        actividades: List<EventoActividadModel>.from(
            json['actividades'].map((e) => EventoActividadModel.fromJson(e))),
      );
  Map<String, dynamic> toJson() => {
        'id_planer': idPlanner,
        'nombre_planer': nombrePlaner,
        'id_planer_old': idPlanerOld,
        'actividades': actividades.map((e) => e.toJson()).toList()
      };
}

class EventoActividadModel {
  int idActividad;
  String nombreActividad;
  String descripcionActividad;
  bool visibleInvolucrado = false;
  int diasActividad;
  int predecesorActividad;
  int idEvento;
  bool estadoCalendarioActividad;
  DateTime fechaInicioActividad;
  DateTime fechaFinActividad;
  int idActividadOld;
  bool estatusProgreso;
  String responsable;
  String estatus;
  DateTime fechaInicioEvento;
  DateTime fechaFinEvento;
  bool enable;

  EventoActividadModel({
    this.idActividad,
    this.nombreActividad,
    this.descripcionActividad,
    this.visibleInvolucrado,
    this.diasActividad = 0,
    this.predecesorActividad,
    this.estadoCalendarioActividad,
    this.fechaInicioActividad,
    this.idActividadOld,
    this.estatusProgreso,
    this.responsable,
    this.estatus,
    this.fechaFinEvento,
    this.fechaInicioEvento,
    this.enable = false,
    this.fechaFinActividad,
    this.idEvento,
  });

  factory EventoActividadModel.fromJson(Map<String, dynamic> json) =>
      EventoActividadModel(
          idActividad: json['id_actividad'],
          nombreActividad: json['nombre_actividad'],
          descripcionActividad: json['descripcion_actividad'],
          visibleInvolucrado: json['visible_involucrados_actividad'],
          diasActividad: json['dias_actividad'],
          predecesorActividad: json['predecesor_actividad'],
          estadoCalendarioActividad: json['estado_calendario_actividad'],
          fechaInicioActividad:
              DateTime.tryParse(json['fecha_inicio_actividad']).toLocal(),
          fechaFinActividad: json['fecha_fin_actividad'] != null
              ? DateTime.tryParse(json['fecha_fin_actividad']).toLocal()
              : null,
          idActividadOld: json['id_actividad_old'],
          estatusProgreso: json['estatus_progreso'],
          responsable: json['responsable'],
          estatus: json['estatus'],
          fechaFinEvento: json['fecha_final_evento'] != null
              ? DateTime.tryParse(json['fecha_final_evento']).toLocal()
              : null,
          fechaInicioEvento: json['fecha_inicio_evento'] != null
              ? DateTime.tryParse(json['fecha_inicio_evento']).toLocal()
              : null,
          idEvento: json['id_evento']);

  Map<String, dynamic> toJson() => {
        'id_actividad': idActividad,
        'nombre_actividad': nombreActividad,
        'descripcion_actividad': descripcionActividad,
        'visible_involucrados_actividad': visibleInvolucrado,
        'dias_actividad': diasActividad,
        'predecesor_actividad': predecesorActividad,
        'estado_calendario_actividad': estadoCalendarioActividad,
        'fecha_inicio_actividad': fechaInicioActividad.toString(),
        'fecha_fin_actividad': fechaFinActividad.toString(),
        'id_actividad_old': idActividadOld,
        'estatus_progreso': estatusProgreso,
        'responsable': responsable,
        'estatus': estatus,
        'fecha_final_evento': fechaFinEvento.toString(),
        'fecha_inicio_evento': fechaInicioEvento.toString(),
        'id_evento': idEvento,
      };
}
