class PerfilPlannerModel {
  PerfilPlannerModel({
    this.iDPlanner,
    this.correo,
    this.direccion,
    this.telefono,
    this.logo,
    this.contrasena,
    this.nombreCompleto,
    this.nombreDeLaEmpresa,
  });

  int? iDPlanner;
  String? nombreCompleto;
  String? correo;
  String? direccion;
  String? telefono;
  String? logo;
  String? contrasena;
  String? nombreDeLaEmpresa;

  factory PerfilPlannerModel.fromJson(Map<String, dynamic> json) =>
      PerfilPlannerModel(
          iDPlanner: json['id_planner'],
          nombreCompleto: json['nombre_completo'],
          correo: json['correo'],
          direccion: json['direccion'],
          telefono: json['telefono'],
          logo: json['logo'],
          contrasena: json['contrasena'],
          nombreDeLaEmpresa: json['nombre_empresa']);

  Map<String, dynamic> toJson() => {
        'id_planner': iDPlanner,
        'nombre_completo': nombreCompleto,
        'correo': correo,
        'direccion': direccion,
        'telefono': telefono,
        'logo': logo,
        'contrasena': contrasena,
        'nombre_empresa': nombreDeLaEmpresa,
      };
}
