import 'dart:ui';

class DashboardEventoModel {
  int? idEvento;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  int? idTipoEvento;
  int? idPlanner;
  String? descripcion;
  String? estatus;
  DateTime? fechaEvento;
  bool isAllDay;
  Color? background;

  DashboardEventoModel({
    this.idEvento,
    this.fechaInicio,
    this.fechaFin,
    this.idTipoEvento,
    this.idPlanner,
    this.descripcion,
    this.estatus,
    this.fechaEvento,
    this.isAllDay = false,
    this.background,
  });

  factory DashboardEventoModel.fromJson(Map<String, dynamic> json) =>
      DashboardEventoModel(
        idEvento: json['id_evento'],
        fechaInicio: DateTime.tryParse(json['fecha_inicio'])!.toLocal(),
        fechaFin: DateTime.tryParse(json['fecha_fin'])!.toLocal(),
        idTipoEvento: json['id_tipo_evento'],
        idPlanner: json['id_planner'],
        descripcion: json['descripcion'],
        estatus: json['estatus'],
        fechaEvento: DateTime.tryParse(json['fecha_evento'])!.toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id_evento': idEvento,
        'fecha_inicio': fechaInicio.toString(),
        'fecha_fin': fechaFin.toString(),
        'id_tipo_evento': idTipoEvento,
        'id_planner': idPlanner,
        'descripcion': descripcion,
        'estatus': estatus,
        'fecha_evento': fechaEvento.toString(),
      };
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
