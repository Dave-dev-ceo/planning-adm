class InvitadosModel {
  InvitadosModel({
    this.acompanantes,
    this.asistencia,
    this.codigoPais,
    this.correo,
    this.grupo,
    this.idInvitado,
    this.nombre,
    this.telefono,
  });

  int? acompanantes;
  int? idInvitado;
  String? asistencia;
  String? codigoPais;
  String? correo;
  String? grupo;
  String? nombre;
  String? telefono;

  factory InvitadosModel.fromJson(Map<String, dynamic> json) => InvitadosModel(
        acompanantes: int.parse(json['acompanantes']),
        asistencia: json['asistencia'],
        codigoPais: json['codigoPais'],
        correo: json['correo'],
        grupo: json['grupo'],
        idInvitado: json['id_Invitado'],
        nombre: json['nombre'],
        telefono: json['telefono'],
      );

  Map<String, dynamic> toJson() => {
        'acompanantes': acompanantes,
        'asistencia': asistencia,
        'codigoPais': codigoPais,
        'correo': correo,
        'grupo': grupo,
        'idInvitado': idInvitado,
        'nombre': nombre,
        'telefono': telefono,
      };
}
