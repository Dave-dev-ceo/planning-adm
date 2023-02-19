class PlannerModel {
  int? idUsuario;
  int? idPlanner;
  String? nombreCompleto;
  String? direccion;
  String? correo;
  String? telefono;
  String? nombreEmpresa;
  String? estatus;

  PlannerModel({
    this.idUsuario,
    this.idPlanner,
    this.nombreCompleto,
    this.direccion,
    this.telefono,
    this.nombreEmpresa,
    this.estatus,
    this.correo,
  });

  Map<String, dynamic> toJson() => {
        'id_usuario': idUsuario,
        'id_planner': idPlanner,
        'nombre_completo': nombreCompleto,
        'direccion': direccion,
        'telefono': telefono,
        'nombre_empresa': nombreEmpresa,
        'estatus': estatus,
        'correo': correo,
      };

  factory PlannerModel.fromJson(Map<String, dynamic> json) {
    return PlannerModel(
      idUsuario: json['id_usuario']?.toInt() ?? 0,
      idPlanner: json['id_planner']?.toInt() ?? 0,
      nombreCompleto: json['nombre_completo'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      nombreEmpresa: json['nombre_empresa'] ?? '',
      estatus: json['estatus'] ?? '',
      correo: json['correo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PlannerModel(idUsuario: $idUsuario, idPlanner: $idPlanner, nombreCompleto: $nombreCompleto, direccion: $direccion, telefono: $telefono, nombreEmpresa: $nombreEmpresa, estatus: $estatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlannerModel &&
        other.idUsuario == idUsuario &&
        other.idPlanner == idPlanner &&
        other.nombreCompleto == nombreCompleto &&
        other.direccion == direccion &&
        other.telefono == telefono &&
        other.nombreEmpresa == nombreEmpresa &&
        other.estatus == estatus &&
        other.correo == correo;
  }

  @override
  int get hashCode {
    return idUsuario.hashCode ^
        idPlanner.hashCode ^
        nombreCompleto.hashCode ^
        direccion.hashCode ^
        telefono.hashCode ^
        nombreEmpresa.hashCode ^
        estatus.hashCode ^
        correo.hashCode;
  }
}
