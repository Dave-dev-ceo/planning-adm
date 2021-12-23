class EtapasModel {
  int idEtapa;
  int ordenEtapa;
  int idPlanner;
  String claveEtapa;
  String nombreEtapa;
  String descripcionEtapa;
  bool isEditNombreEtapa;
  bool isAdd;
  String color;
  List<ProspectoModel> prospectos;

  EtapasModel({
    this.idEtapa,
    this.ordenEtapa,
    this.idPlanner,
    this.claveEtapa,
    this.nombreEtapa,
    this.descripcionEtapa,
    this.isAdd = false,
    this.isEditNombreEtapa = false,
    this.prospectos,
    this.color,
  });

  factory EtapasModel.fromJson(Map<String, dynamic> json) => EtapasModel(
      idEtapa: json['id_etapa'],
      ordenEtapa: json['orden_etapa'],
      color: json['color'],
      idPlanner: json['id_planner'],
      claveEtapa: json['clave_etapa'],
      nombreEtapa: json['nombre_etapa'],
      descripcionEtapa: json['descripcion_etapa'],
      prospectos: List<ProspectoModel>.from(
          json['prospectos'].map((p) => ProspectoModel.fromJson(p))));

  Map<String, dynamic> toJson() => {
        'id_etapa': idEtapa,
        'orden_etapa': ordenEtapa,
        'clave_etapa': claveEtapa,
        'nombre_etapa': nombreEtapa,
        'descripcion_etapa': descripcionEtapa,
        'prospectos': (prospectos != null)
            ? prospectos.map((e) => e.toJson()).toList()
            : []
      };
}

class ProspectoModel {
  int idProspecto;
  int idPlanner;
  int idEtapa;
  String nombreProspecto;
  String descripcion;
  String involucradoProspecto;
  int telefono;
  String correo;
  List<ActividadProspectoModel> actividades;

  ProspectoModel({
    this.idProspecto,
    this.idPlanner,
    this.idEtapa,
    this.descripcion,
    this.involucradoProspecto,
    this.telefono,
    this.correo,
    this.actividades,
    this.nombreProspecto,
  });

  factory ProspectoModel.fromJson(Map<String, dynamic> json) => ProspectoModel(
      idProspecto: json['id_prospecto'],
      idPlanner: json['id_planner'],
      nombreProspecto: json['nombre_prospecto'],
      idEtapa: json['id_etapa'],
      descripcion: json['descripcion'],
      involucradoProspecto: json['involucrado_prospecto'],
      telefono: (json['telefono'] != null) ? int.parse(json['telefono']) : null,
      correo: json['correo'],
      actividades: List<ActividadProspectoModel>.from(
          json['actividades'].map((a) => ActividadProspectoModel.fromJson(a))));
  Map<String, dynamic> toJson() => {
        'id_prospecto': idProspecto,
        'id_planner': idPlanner,
        'id_etapa': idEtapa,
        'nombre_prospecto': nombreProspecto,
        'descripcion': descripcion,
        'involucrado_prospecto': involucradoProspecto,
        'telefono': telefono,
        'correo': correo,
        'actividades': (actividades != null)
            ? actividades.map((e) => e.toJson()).toList()
            : []
      };
}

class ActividadProspectoModel {
  int idActividad;
  int idProspecto;
  String descripcion;
  bool isEdit;

  ActividadProspectoModel({
    this.idActividad,
    this.idProspecto,
    this.descripcion,
    this.isEdit = false,
  });

  factory ActividadProspectoModel.fromJson(Map<String, dynamic> json) =>
      ActividadProspectoModel(
        idActividad: json['id_actividad'],
        idProspecto: json['id_prospecto'],
        descripcion: json['descripcion_actividad'],
      );
  Map<String, dynamic> toJson() => {
        'id_etapa': idActividad,
        'id_prospecto': idProspecto,
        'descripcion_actividad': descripcion,
      };
}

class UpdateEtapaModel {
  int idEtapa;
  int ordenEtapa;

  UpdateEtapaModel({
    this.idEtapa,
    this.ordenEtapa,
  });

  Map<String, dynamic> toJson() => {
        'id_etapa': idEtapa,
        'orden_etapa': ordenEtapa,
      };
}
